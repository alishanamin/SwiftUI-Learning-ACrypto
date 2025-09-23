import Foundation
import Combine

class CoinService {
    @Published var allCoins: [CoinModel] = []
    @Published var marketStats: MarketStats?
    @Published var isFetchingCoins: Bool = false
    @Published var isFetchingStats: Bool = false
    @Published var serviceError: Error?

    private var coinSubscription: AnyCancellable?
    private var statsSubscription: AnyCancellable?
    
    init() {
        getCoins()
        getMarketStats()
    }

    func getCoins() {
        guard let url = URL(string:
                                "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
        ) else { return }

        isFetchingCoins = true

        coinSubscription = NetworkManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: { completion in
                    NetworkManager.handleCompletion(
                        completion,
                        onFinished: {
                            [weak self] in self?.isFetchingCoins = false
                        },
                        onError: { [weak self] error in
                            self?.isFetchingCoins = false
                            self?.serviceError = error
                        }
                    )
                },
                receiveValue: { [weak self] coins in
                    self?.allCoins = coins
                })
    }
    
    func getMarketStats() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {
            return
        }

        isFetchingStats = true

        statsSubscription = NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(
                receiveCompletion: { completion in
                    NetworkManager.handleCompletion(
                        completion,
                        onFinished: {
                            [weak self] in self?.isFetchingStats = false
                        },
                        onError: { [weak self] error in
                            self?.isFetchingStats = false
                            self?.serviceError = error
                        }
                    )
                },
                receiveValue: { [weak self] globalData in
                    self?.marketStats = globalData.data
                })
    }
}

