import Combine
import Foundation
import Core
import Moya
import CombineMoya
import Utility

private class AutoLoginCache {
    static var cache: [String: AnyPublisher<Void, Error>] = [:]
    static let lock = NSLock()
}

private struct AutoLoginRequest: Encodable {
    let adminID: String
    let password: String
    let deviceToken: String?

    enum CodingKeys: String, CodingKey {
        case adminID = "admin_id"
        case password
        case deviceToken = "device_token"
    }
}

private struct AutoLoginResponse: Decodable {
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

private enum AutoLoginAPI {
    case signin(AutoLoginRequest)
}

extension AutoLoginAPI: TargetType {
    var baseURL: URL {
        URLUtil.baseURL
    }

    var path: String {
        switch self {
        case .signin:
            return "/admin/login"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signin:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .signin(let params):
            return .requestJSONEncodable(params)
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

open class BaseRemoteDataSource<API: PiCKAPI> {
    private let keychain: any Keychain
    private let provider: MoyaProvider<API>

    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<API>(plugins: [MoyaLoggingPlugin()])
    }

    public func request(_ api: API, isRetry: Bool = false) -> AnyPublisher<Response, Error> {
        provider.requestPublisher(api)
            .timeout(.seconds(120), scheduler: DispatchQueue.main)
            .tryCatch { [weak self] error -> AnyPublisher<Response, Error> in
                guard let self = self else { throw error }
                guard let moyaError = error as? MoyaError,
                      let code = moyaError.response?.statusCode else {
                    throw error
                }

                if code == 401 {
                    if api.pickHeader == .tokenIsEmpty {
                        throw api.errorMap?[code] ??
                            PiCKError.error(
                                message: (try? moyaError.response?
                                    .mapJSON() as? NSDictionary)?["message"] as? String ?? "",
                                errorBody: [:]
                            )
                    }

                    if !isRetry {
                        return self.autoLogin()
                            .flatMap { _ -> AnyPublisher<Response, Error> in
                                return self.request(api, isRetry: true)
                            }
                            .eraseToAnyPublisher()
                    }
                }

                let serverMessage = (try? moyaError.response?
                    .mapJSON() as? NSDictionary)?["message"] as? String ?? ""

                if !serverMessage.isEmpty {
                    throw PiCKError.error(message: serverMessage, errorBody: [:])
                }

                throw api.errorMap?[code] ?? PiCKError.error(message: "오류가 발생했습니다.", errorBody: [:])
            }
            .eraseToAnyPublisher()
    }

    private func autoLogin() -> AnyPublisher<Void, Error> {
        let key = String(describing: API.self)

        AutoLoginCache.lock.lock()

        if let ongoing = AutoLoginCache.cache[key] {
            AutoLoginCache.lock.unlock()
            return ongoing
        }

        let adminID = keychain.load(type: .id)
        let password = keychain.load(type: .password)

        guard !adminID.isEmpty, !password.isEmpty else {
            AutoLoginCache.lock.unlock()
            clearAuthData()
            NotificationCenter.default.post(name: .autoLoginDidFail, object: nil)
            return Fail(error: PiCKError.error(message: "저장된 인증 정보가 없습니다.", errorBody: [:])).eraseToAnyPublisher()
        }

        let deviceToken = UserDefaultStorage.shared.get(forKey: .deviceToken) as? String

        let loginRequest = AutoLoginRequest(
            adminID: adminID,
            password: password,
            deviceToken: deviceToken
        )

        let authProvider = MoyaProvider<AutoLoginAPI>(plugins: [MoyaLoggingPlugin()])

        let autoLogin = Future<Void, Error> { [weak self] promise in
            authProvider.request(.signin(loginRequest)) { result in
                switch result {
                case .success(let response):
                    do {
                        let token = try response.map(AutoLoginResponse.self)
                        guard self != nil else { return }
                        JwtStore.shared.accessToken = token.accessToken
                        promise(.success(()))
                    } catch {
                        self?.clearAuthData()
                        NotificationCenter.default.post(name: .autoLoginDidFail, object: nil)
                        promise(.failure(error))
                    }
                case .failure(let error):
                    self?.clearAuthData()
                    NotificationCenter.default.post(name: .autoLoginDidFail, object: nil)
                    promise(.failure(error))
                }
            }
        }
        .handleEvents(
            receiveCompletion: { _ in
                AutoLoginCache.lock.lock()
                AutoLoginCache.cache.removeValue(forKey: key)
                AutoLoginCache.lock.unlock()
            }
        )
        .share()
        .eraseToAnyPublisher()

        AutoLoginCache.cache[key] = autoLogin
        AutoLoginCache.lock.unlock()

        return autoLogin
    }

    private func clearAuthData() {
        JwtStore.shared.clearTokens()
        keychain.delete(type: .id)
        keychain.delete(type: .password)
        UserDefaultStorage.shared.remove(forKey: .userInfoData)
    }
    
    public func requestText(_ api: API) -> AnyPublisher<String, Error> {
        request(api)
            .tryMap { response in
                guard let text = String(data: response.data, encoding: .utf8) else {
                    throw NSError(
                        domain: "EncodingError",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Failed to decode response as UTF-8"]
                    )
                }
                return text
            }
            .eraseToAnyPublisher()
    }
}
