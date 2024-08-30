import XCTest
import Dagger

final class DaggerTests: XCTestCase {
    func test_python_v() async throws {
        // Given
        let stdout = try await Dagger.connect(config: Config())
            .container()
            .from(address: "python")
            .withExec(args: ["python", "-V"])
            .stdout()
        
    }
}
