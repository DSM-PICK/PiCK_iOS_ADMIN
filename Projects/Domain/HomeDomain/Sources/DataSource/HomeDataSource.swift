import Foundation

public protocol HomeDataSource {
    func getSelfStudyDirector(date: String) async throws -> [SelfStudyDirectorResponseDTO]
    func getAdminSelfStudyInfo() async throws -> String
}
