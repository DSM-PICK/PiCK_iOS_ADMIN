import XCTest
import Combine
import ComposableArchitecture
import HomeDomainInterface
import AcceptDomainInterface
import OutListDomainInterface
import ClassroomMoveListDomainInterface
@testable import HomeFeature

@MainActor
final class HomeFeatureTests: XCTestCase {
    func testSelfStudyAndClassroomResponse_WhenTeacherRolesExist_RequestsAllRelatedLists() async {
        let classroomMoveUseCase = GetClassroomMoveByFloorUseCaseSpy()
        let outListUseCase = GetOutListUseCaseSpy()
        let earlyReturnUseCase = GetEarlyReturnUseCaseSpy()
        let allApplicationsUseCase = GetAllApplicationsUseCaseSpy()
        let earlyReturnByGradeUseCase = GetEarlyReturnByGradeUseCaseSpy()
        let store = makeStore(
            getAllApplicationsUseCase: allApplicationsUseCase,
            getEarlyReturnByGradeUseCase: earlyReturnByGradeUseCase,
            getClassroomMoveByFloorUseCase: classroomMoveUseCase,
            getOutListUseCase: outListUseCase,
            getEarlyReturnUseCase: earlyReturnUseCase
        )

        await store.send(
            .selfStudyAndClassroomResponse(
                .success(.init(selfStudyFloor: 3, grade: 2, classNum: 4))
            )
        ) {
            $0.classroom = "2-4"
            $0.floor = "3층"
            $0.isHomeroomTeacher = true
            $0.isSelfStudyTeacher = true
        }

        XCTAssertEqual(classroomMoveUseCase.requestedFloors, [3])
        XCTAssertEqual(outListUseCase.requestedFloors, [3])
        XCTAssertEqual(earlyReturnUseCase.requestedArguments.count, 1)
        XCTAssertEqual(earlyReturnUseCase.requestedArguments.first?.floor, 3)
        XCTAssertEqual(earlyReturnUseCase.requestedArguments.first?.status, "OK")
        XCTAssertEqual(allApplicationsUseCase.requestedArguments.count, 1)
        XCTAssertEqual(allApplicationsUseCase.requestedArguments.first?.grade, 2)
        XCTAssertEqual(allApplicationsUseCase.requestedArguments.first?.classNum, 4)
        XCTAssertEqual(earlyReturnByGradeUseCase.requestedArguments.count, 1)
        XCTAssertEqual(earlyReturnByGradeUseCase.requestedArguments.first?.grade, 2)
        XCTAssertEqual(earlyReturnByGradeUseCase.requestedArguments.first?.classNum, 4)
    }

    func testAcceptResponse_CombinesAndSortsOutingAcceptList() async {
        var initialState = HomeReducer.State()
        initialState.earlyReturnAcceptList = [
            .init(
                id: "early-return",
                userName: "조기귀가",
                start: "11:00",
                grade: 2,
                classNum: 1,
                num: 2,
                reason: "병원"
            )
        ]
        let store = makeStore(initialState: initialState)
        let applications = [
            ApplicationEntity(
                id: "application",
                userId: "user-1",
                userName: "외출",
                start: "09:00",
                end: "10:00",
                grade: 1,
                classNum: 3,
                num: 5,
                reason: "상담"
            )
        ]

        await store.send(.acceptResponse(.success(applications))) {
            $0.acceptList = applications
            $0.outingAcceptList = [
                .init(from: applications[0]),
                .init(from: initialState.earlyReturnAcceptList[0])
            ]
        }
    }

    func testEarlyReturnListResponse_CombinesAndSortsOutingStudentList() async {
        var initialState = HomeReducer.State()
        initialState.outList = [
            .init(
                id: "outing",
                userId: "user-1",
                userName: "외출자",
                start: "08:30",
                end: "09:30",
                grade: 2,
                classNum: 2,
                num: 8,
                reason: "병원"
            )
        ]
        let store = makeStore(initialState: initialState)
        let earlyReturns = [
            EarlyReturnEntity(
                id: "return",
                userName: "조기귀가자",
                start: "10:00",
                grade: 1,
                classNum: 4,
                num: 1,
                reason: "진료"
            )
        ]

        await store.send(.earlyReturnListResponse(.success(earlyReturns))) {
            $0.earlyReturnList = earlyReturns
            $0.outingStudentList = [
                .init(from: earlyReturns[0]),
                .init(from: initialState.outList[0])
            ]
        }
    }
}

private extension HomeFeatureTests {
    func makeStore(
        getSelfStudyDirectorUseCase:
            any GetSelfStudyDirectorUseCaseProtocol = GetSelfStudyDirectorUseCaseSpy(),
        getAdminSelfStudyInfoUseCase:
            any GetAdminSelfStudyInfoUseCaseProtocol = GetAdminSelfStudyInfoUseCaseSpy(),
        getSelfStudyAndClassroomUseCase:
            any GetSelfStudyAndClassroomUseCase = GetSelfStudyAndClassroomUseCaseSpy(),
        getAllApplicationsUseCase:
            any GetAllApplicationsUseCaseProtocol = GetAllApplicationsUseCaseSpy(),
        updateApplicationStatusUseCase:
            any UpdateApplicationStatusUseCaseProtocol = UpdateApplicationStatusUseCaseSpy(),
        getEarlyReturnByGradeUseCase:
            any GetEarlyReturnByGradeUseCaseProtocol = GetEarlyReturnByGradeUseCaseSpy(),
        updateEarlyReturnStatusUseCase:
            any UpdateEarlyReturnStatusUseCaseProtocol = UpdateEarlyReturnStatusUseCaseSpy(),
        getClassroomMoveByFloorUseCase: any GetClassroomMoveByFloorUseCase = GetClassroomMoveByFloorUseCaseSpy(),
        getOutListUseCase: any GetOutListUseCase = GetOutListUseCaseSpy(),
        getEarlyReturnUseCase: any GetEarlyReturnUseCase = GetEarlyReturnUseCaseSpy(),
        initialState: HomeReducer.State = .init()
    ) -> TestStore<HomeReducer.State, HomeReducer.Action> {
        TestStore(initialState: initialState) {
            HomeReducer(
                getSelfStudyDirectorUseCase: getSelfStudyDirectorUseCase,
                getAdminSelfStudyInfoUseCase: getAdminSelfStudyInfoUseCase,
                getSelfStudyAndClassroomUseCase: getSelfStudyAndClassroomUseCase,
                getAllApplicationsUseCase: getAllApplicationsUseCase,
                updateApplicationStatusUseCase: updateApplicationStatusUseCase,
                getEarlyReturnByGradeUseCase: getEarlyReturnByGradeUseCase,
                updateEarlyReturnStatusUseCase: updateEarlyReturnStatusUseCase,
                getClassroomMoveByFloorUseCase: getClassroomMoveByFloorUseCase,
                getOutListUseCase: getOutListUseCase,
                getEarlyReturnUseCase: getEarlyReturnUseCase
            )
        }
    }
}

private final class GetSelfStudyDirectorUseCaseSpy: GetSelfStudyDirectorUseCaseProtocol {
    func execute(date: String) -> AnyPublisher<[SelfStudyDirectorEntity], Error> {
        Empty(completeImmediately: true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private final class GetAdminSelfStudyInfoUseCaseSpy: GetAdminSelfStudyInfoUseCaseProtocol {
    func execute() -> AnyPublisher<String, Error> {
        Empty(completeImmediately: true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private final class GetSelfStudyAndClassroomUseCaseSpy: GetSelfStudyAndClassroomUseCase {
    func execute() -> AnyPublisher<GetSelfStudyAndClassroomEntity, Error> {
        Empty(completeImmediately: true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private final class GetAllApplicationsUseCaseSpy: GetAllApplicationsUseCaseProtocol {
    private(set) var requestedArguments: [(grade: Int, classNum: Int)] = []

    func execute(grade: Int, classNum: Int) -> AnyPublisher<[ApplicationEntity], Error> {
        requestedArguments.append((grade, classNum))
        return Empty(completeImmediately: true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private final class UpdateApplicationStatusUseCaseSpy: UpdateApplicationStatusUseCaseProtocol {
    func execute(status: String, idList: [String]) -> AnyPublisher<Void, Error> {
        Empty(completeImmediately: true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private final class GetEarlyReturnByGradeUseCaseSpy: GetEarlyReturnByGradeUseCaseProtocol {
    private(set) var requestedArguments: [(grade: Int, classNum: Int)] = []

    func execute(grade: Int, classNum: Int) -> AnyPublisher<[EarlyReturnAcceptEntity], Error> {
        requestedArguments.append((grade, classNum))
        return Empty(completeImmediately: true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private final class UpdateEarlyReturnStatusUseCaseSpy: UpdateEarlyReturnStatusUseCaseProtocol {
    func execute(status: String, idList: [String]) -> AnyPublisher<Void, Error> {
        Empty(completeImmediately: true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private final class GetClassroomMoveByFloorUseCaseSpy: GetClassroomMoveByFloorUseCase {
    private(set) var requestedFloors: [Int] = []

    func execute(floor: Int) -> AnyPublisher<[ClassroomMoveListEntity], Error> {
        requestedFloors.append(floor)
        return Empty(completeImmediately: true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private final class GetOutListUseCaseSpy: GetOutListUseCase {
    private(set) var requestedFloors: [Int] = []

    func execute(floor: Int) -> AnyPublisher<[OutListEntity], Error> {
        requestedFloors.append(floor)
        return Empty(completeImmediately: true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private final class GetEarlyReturnUseCaseSpy: GetEarlyReturnUseCase {
    private(set) var requestedArguments: [(floor: Int, status: String)] = []

    func execute(floor: Int, status: String) -> AnyPublisher<[EarlyReturnEntity], Error> {
        requestedArguments.append((floor, status))
        return Empty(completeImmediately: true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
