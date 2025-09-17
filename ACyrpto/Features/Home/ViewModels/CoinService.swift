import Foundation
import Combine

class CoinService {
    @Published var allCoins: [CoinModel] = []
    @Published var isFetching: Bool = false
    @Published var serviceError: Error?

    private var coinSubscription: AnyCancellable?
    
    init(){
        getCoins()
    }

    func getCoins() {
        guard let url = URL(string:
            "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
        else { return }

        isFetching = true

        coinSubscription = NetworkManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(
                receiveCompletion:  { completion in
                    NetworkManager.handleCompletion(
                        completion,
                        onFinished: { [weak self] in
                            self?.isFetching = false
                        },
                        onError: { [weak self] error in
                            self?.isFetching = false
                            self?.serviceError = error
                        }
                    )
                },
                receiveValue: { [weak self] coins in
                    self?.allCoins = coins
                })
    }
}


