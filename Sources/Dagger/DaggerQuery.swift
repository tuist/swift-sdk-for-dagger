import Foundation

enum DaggerQueryComponentParent: Sendable {
    case component(DaggerQueryComponent)
    case client(Dagger)
    
    var client: Dagger? {
        switch self {
        case .component(_): return nil
        case .client(let client): return client
        }
    }
}

indirect enum DaggerQueryComponentArgument: Sendable {
    case string(String)
    case array([DaggerQueryComponentArgument])
    
    var queryValue: String {
        switch self {
        case .string(let value): return "\"\(value)\""
        case .array(let values): return "[\(values.map(\.queryValue).joined(separator: ", "))]"
        }
    }
}

protocol DaggerQueryComponent: Sendable {
    var field: String { get }
    var arguments: [String: DaggerQueryComponentArgument]? { get }
    var parent: DaggerQueryComponentParent { get }
}

struct DaggerQueryFieldComponent: DaggerQueryComponent {
    let field: String
    let arguments: [String : DaggerQueryComponentArgument]? = nil
    let parent: DaggerQueryComponentParent
    
    init(field: String, parent: DaggerQueryComponentParent) {
        self.field = field
        self.parent = parent
    }
}

extension DaggerQueryComponent {

    func completeAndRun<T>(withField field: String) async throws -> T {
        var client: Dagger!
        var components: [DaggerQueryComponent] = [DaggerQueryFieldComponent(field: field, parent: .component(self))]
        components.insert(self, at: 0)
        while case let DaggerQueryComponentParent.component(parent) = components.first!.parent {
            components.insert(parent, at: 0)
        }
        client = components.first!.parent.client!
        let query = "{ \(query(components)) }"

        let body = try await client.query(query)
        var keys = ["data"]
        keys.append(contentsOf: components.map(\.field))
        return dig(body, keys: keys) as! T
    }
    
    func query(_ components: [DaggerQueryComponent]) -> String {
        if let component = components.first {

            if component.arguments?.isEmpty == false {
                return "\(component.field)(\(component.arguments!.map({"\($0.key): \($0.value.queryValue)"}).joined(separator: ", "))) { \(query(Array(components.dropFirst()))) }"
            } else {
                let next = Array(components.dropFirst())
                return next.isEmpty ? "\(component.field)" : "\(component.field) { \(query(next)) }"
            }
        } else {
            return ""
        }
    }
    
    func dig(_ object: Any, keys: [String]) -> Any {
        if let key = keys.first {
            return dig((object as! [String: Any])[key]!, keys: Array(keys.dropFirst()))
        } else {
            return object
        }
    }
    
}
