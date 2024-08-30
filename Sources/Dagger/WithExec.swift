import Foundation

public final class WithExec: Sendable, DaggerQueryComponent {
    var field: String { "withExec" }
    let arguments: [String : DaggerQueryComponentArgument]?
    let parent: DaggerQueryComponentParent
    
    init(args: [String],
         parent: DaggerQueryComponentParent) {
        self.arguments = ["args": .array(args.map({.string($0)}))]
        self.parent = parent
    }
    
    public func stdout() async throws -> String {
        return try await self.completeAndRun(withField: "stdout")
    }

}
