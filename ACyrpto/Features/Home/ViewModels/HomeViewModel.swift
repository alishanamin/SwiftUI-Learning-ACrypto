
import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published private var allCoins: [CoinModel] = []
    @Published var allCoinsList: [CoinModel] = []
    @Published var portFolioCoinsList: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var statsList: [StatisticModel] = []
    @Published private var marketStats: MarketStats?
    @Published var sortOptions: SortOptions = .holdings
    private let coinService: CoinServiceProtocol
    private let portfolioService: PortfolioCoreDataService
    private var cancellables = Set<AnyCancellable>()
    
    
    enum SortOptions {
        
        case rank,rankReversed, price, priceReversed, holdings, holdingsReversed
    }
    
    
    
    init(
        service: CoinServiceProtocol = CoinService(),
        folioService: PortfolioCoreDataService = PortfolioCoreDataService()
    ) {
        self.coinService = service
        self.portfolioService = folioService
        addSubscribers()
        fetchCoins()
        fetchMarketStats()
    }
    
    func updatePortFolio(coin: CoinModel, amount: Double) {
        portfolioService.updatePortFolio(coin: coin, amount: amount)
    }
    
    // MARK: - Subscribers
    private func addSubscribers() {
        // Search filter
        $searchText
            .combineLatest($allCoins,$sortOptions)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map {
                text,coins,sortOption in
                let allCoinsList = self.sortAndFilterAllCoins(text: text, coins: coins, sortOption: sortOption)
                return allCoinsList
            }
            .assign(to: \.allCoinsList, on: self)
            .store(in: &cancellables)
        
        // Portfolio coins with holdings
        $allCoins
            .combineLatest(portfolioService.$portfolio, $sortOptions)
            .map { coins, entities, sortOption in
                var portfolioCoins = self.mapPortFolioCoins(coins: coins, entities: entities)
                self.sortCoins(sort: sortOption, coinList: &portfolioCoins)
                return portfolioCoins
            }
            .assign(to: \.portFolioCoinsList, on: self)
            .store(in: &cancellables)

        
        $marketStats
            .combineLatest($portFolioCoinsList)
            .compactMap {
                marketStats,
                portfolioCoins -> [StatisticModel]? in
                guard let marketStats else { return nil }
                
                let portfolioValue = portfolioCoins.map { $0.currentHoldingsValue }.reduce(0,+)
                
                return [
                    StatisticModel(
                        title: "Total Market Cap",
                        value: marketStats.marketCap,
                        percentageChange: marketStats.marketCapChangePercentage24hUsd
                    ),
                    StatisticModel(
                        title: "Total Market Volume",
                        value: marketStats.marketVolume
                    ),
                    StatisticModel(
                        title: "BTC Dominance",
                        value: marketStats.btcDominance
                    ),
                    StatisticModel(
                        title: "Portfolio",
                        value: portfolioValue.toCurrencyString(code: "$")
                    )
                ]
            }
            .assign(to: \.statsList, on: self)
            .store(in: &cancellables)
        
    }
    
    // MARK: - Fetch
    private func fetchCoins() {
        errorMessage = nil
        isLoading = true
        
        coinService.getCoins()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case let .failure(error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] coins in
                    self?.allCoins = coins
                    self?.allCoinsList = coins
                }
            )
            .store(in: &cancellables)
    }
    
    private func fetchMarketStats() {
        coinService.getMarketStats()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] data in
                    self?.marketStats = data
                }
            )
            .store(in: &cancellables)
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        var updated = coins
        switch sortOptions {
        case .holdings, .holdingsReversed:
                sortCoins(sort: sortOptions, coinList: &updated)
        default:
            break // don’t sort portfolio if sort option isn’t holdings-related
        }
        return updated
    }
    private func sortAndFilterAllCoins(text: String, coins: [CoinModel], sortOption: SortOptions) -> [CoinModel] {
        let filteredCoins: [CoinModel]
        
        if text.isEmpty {
        
            filteredCoins = Array(coins)
        } else {
            filteredCoins = coins.filter {
                $0.name.lowercased().contains(text.lowercased()) ||
                $0.symbol.lowercased().contains(text.lowercased())
            }
        }

        var result = filteredCoins
        sortCoins(sort: sortOption, coinList: &result)
        return result
    }

   
    
    private func sortCoins(sort: SortOptions, coinList: inout [CoinModel]) {
        switch sort {
        case .rank,.holdings:
            coinList.sort(by: { $0.rank < $1.rank })
        case .rankReversed,.holdingsReversed:
            coinList.sort(by: { $0.rank > $1.rank })
        case .price:
            coinList.sort(by: { $0.currentPrice < $1.currentPrice })
        case .priceReversed:
            coinList.sort(by: { $0.currentPrice > $1.currentPrice })
        }
    }
    //coins, entities
    private func mapPortFolioCoins(coins: [CoinModel], entities:[PortfolioEntity] ) -> [CoinModel]{
        coins.compactMap { coin in
            guard let entity = entities.first(where: { $0.coinID == coin.id }) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
        
        // MARK: - Public Actions
        func refresh() {
            fetchCoins()
            fetchMarketStats()
        }
        
        func retry() {
            fetchCoins()
            fetchMarketStats()
        }
    }

