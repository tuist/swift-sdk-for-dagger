import Foundation

public final class From: Sendable, DaggerQueryComponent {
    var field: String { "from" }
    let arguments: [String : DaggerQueryComponentArgument]?
    let parent: DaggerQueryComponentParent
    
    init(address: String,
         parent: DaggerQueryComponentParent) {
        self.arguments = ["address": .string(address)]
        self.parent = parent
    }
    
    public func withExec(args: [String]) -> WithExec {
        return WithExec(args: args, parent: .component(self))
    }
    
}
