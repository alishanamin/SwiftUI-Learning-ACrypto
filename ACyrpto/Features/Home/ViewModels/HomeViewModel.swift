import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCointsList: [CoinModel] = []
    @Published var portFolioCointsList: [CoinModel] =  []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var searchText: String = ""

    private let coinService = CoinService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchCoinsSubscriber()
        
    }

    private func fetchCoinsSubscriber() {
        
        $searchText
            .combineLatest(coinService.$allCoins)
            .map { text, coins -> (String, [CoinModel]) in
                if text.isEmpty {
                    return ("", coins)
                }
                let lower = text.lowercased()
                let filtered = coins.filter {
                    $0.name.lowercased().contains(lower) ||
                    $0.symbol.lowercased().contains(lower)
                }
                return (text, filtered)
            }
            .sink { [weak self] (text, coins) in
                guard let self = self else { return }
                
                self.allCointsList = coins

                if text.isEmpty {
                    self.errorMessage = nil
                } else if coins.isEmpty {
                    self.errorMessage = "No coins found for “\(text)”"
                } else {
                    self.errorMessage = nil
                }
            }
            .store(in: &cancellables)

        coinService.$isFetching
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)

        coinService.$serviceError
            .compactMap { $0?.localizedDescription }
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Private
       private func fetchCoins() {
           self.allCointsList = []
           coinService.getCoins()
       }
    
    // MARK: - Public actions
        func refresh() {
            fetchCoins()
        }

        func retry() {
            fetchCoins()
        }
    
    
}


