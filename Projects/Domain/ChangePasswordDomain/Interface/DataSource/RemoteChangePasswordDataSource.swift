import Combine

public protocol RemoteChangePasswordDataSource {
    func changePassword(req: PasswordChangeRequestParams) -> AnyPublisher<Void, Error>
}
