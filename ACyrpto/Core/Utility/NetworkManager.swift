import Foundation
import Combine

struct APIError: Decodable {
    let status: Status
    struct Status: Decodable {
        let error_code: Int
        let error_message: String
    }
}

final class NetworkManager {
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        LoggerService.shared.i("🌐 [REQUEST] GET \(url.absoluteString)")
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .handleEvents(receiveOutput: { output in
                if let http = output.response as? HTTPURLResponse {
                    LoggerService.shared.i("📡 [RESPONSE] \(http.statusCode) for \(url.absoluteString)")
                }
            })
            .tryMap { output -> Data in
                guard let http = output.response as? HTTPURLResponse else {
                    LoggerService.shared.e("❌ Bad server response (no HTTPURLResponse)")
                    throw URLError(.badServerResponse)
                }
                
                let data = output.data
                let decoder = JSONDecoder()
                
                switch http.statusCode {
                case 200..<300:
                    // Sometimes 200 body is an error object
                    if let apiErr = try? decoder.decode(APIError.self, from: data) {
                        LoggerService.shared.e("🚨 API Error \(apiErr.status.error_code): \(apiErr.status.error_message)")
                        throw NSError(
                            domain: "",
                            code: apiErr.status.error_code,
                            userInfo: [NSLocalizedDescriptionKey: apiErr.status.error_message]
                        )
                    }
                    LoggerService.shared.i("✅ Success for \(url.absoluteString)")
                    return data
                    
                case 400..<500:
                    if let apiErr = try? decoder.decode(APIError.self, from: data) {
                        LoggerService.shared.e("🔒 Client error \(apiErr.status.error_code): \(apiErr.status.error_message)")
                        throw NSError(
                            domain: "",
                            code: apiErr.status.error_code,
                            userInfo: [NSLocalizedDescriptionKey: apiErr.status.error_message]
                        )
                    }
                    LoggerService.shared.e("🔒 Client error (\(http.statusCode)) for \(url.absoluteString)")
                    throw NSError(
                        domain: "",
                        code: http.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "Client error (\(http.statusCode))"]
                    )
                    
                case 500..<600:
                    if let apiErr = try? decoder.decode(APIError.self, from: data) {
                        LoggerService.shared.e("💥 Server error \(apiErr.status.error_code): \(apiErr.status.error_message)")
                        throw NSError(
                            domain: "",
                            code: apiErr.status.error_code,
                            userInfo: [NSLocalizedDescriptionKey: apiErr.status.error_message]
                        )
                    }
                    LoggerService.shared.e("💥 Server error (\(http.statusCode)) for \(url.absoluteString)")
                    throw NSError(
                        domain: "",
                        code: http.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "Server error (\(http.statusCode))"]
                    )
                    
                default:
                    LoggerService.shared.e("🌐 Unexpected status \(http.statusCode) for \(url.absoluteString)")
                    throw NSError(
                        domain: "",
                        code: http.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "Unexpected status code \(http.statusCode)"]
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleCompletion(
        _ completion: Subscribers.Completion<Error>,
        onFinished: (() -> Void)? = nil,
        onError: ((Error) -> Void)? = nil
    ) {
        switch completion {
        case .finished:
            LoggerService.shared.i("✅ Request finished")
            onFinished?()
        case .failure(let error):
            LoggerService.shared.e("❌ \(error.localizedDescription)")
            onError?(error)
        }
    }

}

