import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            task.resume()
        }
    }
}


public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public class PearOsSite {

    private let api = "https://pearos.xyz/assets/data"
    private let apiIco = "https://iso.pearos.xyz"
    private let apiStatus = "https://pearsoftwareandservices.statuspage.io/api/v2"

    private var headers: [String: String]

    public init() {
        self.headers = [
            "Connection": "keep-alive",
            "Accept-Encoding": "deflate, zstd",
            "Accept-Language": "en-US,en;q=0.9",
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36"
        ]
    }

    private func fetchJSON(from urlString: String,method: HTTPMethod = .get,body: Data? = nil,queryParameters: [String: String]? = nil) async throws -> Any {
        var urlComponents = URLComponents(string: urlString)
        if let queryParameters = queryParameters {
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents?.url else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }

    public func getStatusSite() async throws -> Any {
        try await fetchJSON(
            from: "\(apiStatus)/status.json"
        )
    }

    public func getChangeLog() async throws -> Any {
        try await fetchJSON(
            from: "\(api)/changelog.json"
        )
    }

    public func getVersions(nameVersion: String) async throws -> Any {
        try await fetchJSON(
            from: "\(api)/\(nameVersion).json"
        )
    }

    public func getCurrency() async throws -> Any {
        try await fetchJSON(from: "\(apiIco)/currency")
    }

    public func getFreePoint(name: String) async throws -> Any {
        guard let url = URL(string: "\(apiIco)/freepoint") else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
    
        let body: [String: Any] = ["file": name]

        let bodyData = try JSONSerialization.data(withJSONObject: body, options: [])
        
        return try await fetchJSON(from: url.absoluteString,method: .post,body: bodyData,queryParameters: nil)
    }
}
