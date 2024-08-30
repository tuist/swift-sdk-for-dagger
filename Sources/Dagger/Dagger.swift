import Foundation

enum DaggerError: Error, CustomStringConvertible {
    case missingPort(envVariable: String)
    case invalidPortNumber(portString: String)
    case missingSessionToken(envVariable: String)

    var description: String {
        switch self {
        case .missingPort(let envVariable): return "The environment variable containing the Dagger session port, $\(envVariable), is absent."
        case .invalidPortNumber(let portString): return "The port value \(portString) is not a valid number."
        case .missingSessionToken(let envVariable): return "The environment variable containing the Dagger session token, $\(envVariable), is absent."
        }
    }
}

public final class Dagger: Sendable {
    private let config: Config
    private let urlSession: URLSession
    private let apiURL: URL
    
    private init(config: Config, apiURL: URL, urlSession: URLSession) {
        self.config = config
        self.apiURL = apiURL
        self.urlSession = urlSession
    }
    
    func query(_ query: String) async throws -> Any {
        var urlComponents = URLComponents(url: self.apiURL, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [URLQueryItem(name: "query", value: query)]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        request.httpBody = try JSONSerialization.data(withJSONObject: ["query": query])
        request.allHTTPHeaderFields = [:]
        request.allHTTPHeaderFields?["Content-Type"] = "application/json"
        let (data, _) = try await urlSession.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public static func connect(config: Config) throws -> Dagger {
        guard let portString = ProcessInfo.processInfo.environment["DAGGER_SESSION_PORT"] else {
            throw DaggerError.missingPort(envVariable: "DAGGER_SESSION_PORT")
        }
        guard let port = Int(portString) else {
            throw DaggerError.invalidPortNumber(portString: portString)
        }
        guard let sessionToken = ProcessInfo.processInfo.environment["DAGGER_SESSION_TOKEN"] else {
            throw DaggerError.missingSessionToken(envVariable: "DAGGER_SESSION_TOKEN")
        }
        let apiURL = URL(string: "http://\(sessionToken):@127.0.0.1:\(port)/query")!
        return Dagger(config: config, apiURL: apiURL, urlSession: .shared)
    }
    
    public func container() -> Container {
        return Container(parent: .client(self))
    }
    
}
