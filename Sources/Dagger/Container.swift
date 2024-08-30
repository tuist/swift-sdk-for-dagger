import Foundation

public final class Container: Sendable, DaggerQueryComponent {
    var field: String { "container" }
    var arguments: [String : DaggerQueryComponentArgument]? { nil }
    let parent: DaggerQueryComponentParent
    
    init(parent: DaggerQueryComponentParent) {
        self.parent = parent
    }
    
    public func from(address: String) -> From {
        return From(address: address, parent: .component(self))
    }
    
}
