import Foundation
import Combine

protocol CoinServiceProtocol {
    func getCoins() -> AnyPublisher<[CoinModel], Error>
    func getMarketStats() -> AnyPublisher<MarketStats, Error>
}

class CoinService: CoinServiceProtocol {
    
    func getCoins() -> AnyPublisher<[CoinModel], Error> {
        guard let url = URL(string:
            "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
        ) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return NetworkManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getMarketStats() -> AnyPublisher<MarketStats, Error> {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .compactMap { $0.data }
            .eraseToAnyPublisher()
    }
}

