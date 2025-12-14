import Foundation
import Combine
import BaseDomain
import Core
import Moya
import CombineMoya
import SelfStudyCheckDomainInterface

public final class SelfStudyCheckDataSourceImpl: SelfStudyCheckDataSource {
    private let keychain: any Keychain
    private let provider: MoyaProvider<SelfStudyCheckAPI>

    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<SelfStudyCheckAPI>(plugins: [MoyaLoggingPlugin()])
    }

    public func getStudentAttendance(grade: Int, classNum: Int, period: Int) -> AnyPublisher<[StudentAttendanceResponseDTO], Error> {
        provider.requestPublisher(.getStudentAttendance(grade: grade, classNum: classNum, period: period))
            .map(\.data)
            .decode(type: [StudentAttendanceResponseDTO].self, decoder: JSONDecoder())
            .mapError { error -> Error in
                if let moyaError = error as? MoyaError,
                   let code = moyaError.response?.statusCode,
                   let errorMap = SelfStudyCheckAPI.getStudentAttendance(grade: grade, classNum: classNum, period: period).errorMap,
                   let mappedError = errorMap[code] {
                    return mappedError
                }
                return error
            }
            .eraseToAnyPublisher()
    }

    public func modifyAttendance(period: Int, attendances: [AttendanceUpdateRequestDTO]) -> AnyPublisher<Void, Error> {
        provider.requestPublisher(.modifyAttendance(period: period, attendances: attendances))
            .map { _ in () }
            .mapError { error -> Error in
                if let moyaError = error as? MoyaError,
                   let code = moyaError.response?.statusCode,
                   let errorMap = SelfStudyCheckAPI.modifyAttendance(period: period, attendances: attendances).errorMap,
                   let mappedError = errorMap[code] {
                    return mappedError
                }
                return error
            }
            .eraseToAnyPublisher()
    }
}
