
import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published private var allCoins: [CoinModel] = []
    @Published var allCoinsList: [CoinModel] = []
    @Published var portFolioCoinsList: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var statsList: [StatsModel] = []
    @Published private var marketStats: MarketStats?


    private let coinService: CoinServiceProtocol
    private let portfolioService: PortfolioCoreDataService
    private var cancellables = Set<AnyCancellable>()

    

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
            .combineLatest($allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { text, coins -> [CoinModel] in
                guard !text.isEmpty else { return coins }
                let lower = text.lowercased()
                return coins.filter {
                    $0.name.lowercased().contains(lower) ||
                    $0.symbol.lowercased().contains(lower)
                }
            }
            .assign(to: \.allCoinsList, on: self)
            .store(in: &cancellables)

        // Portfolio coins with holdings
        $allCoins
            .combineLatest(portfolioService.$portfolio)
            .map { coins, entities -> [CoinModel] in
                coins.compactMap { coin in
                    guard let entity = entities.first(where: { $0.coinID == coin.id }) else {
                        return nil
                    }
                    return coin.updateHoldings(amount: entity.amount)
                }
            }
            .assign(to: \.portFolioCoinsList, on: self)
            .store(in: &cancellables)

        $marketStats
            .combineLatest($portFolioCoinsList)
            .compactMap { marketStats, portfolioCoins -> [StatsModel]? in
                guard let marketStats else { return nil }

                let portfolioValue = portfolioCoins.map { $0.currentHoldingsValue }.reduce(0, +)

                return [
                    StatsModel(
                        title: "Total Market Cap",
                        volume: marketStats.marketCap,
                        percentage: marketStats.marketCapChangePercentage24hUsd
                    ),
                    StatsModel(
                        title: "Total Market Volume",
                        volume: marketStats.marketVolume
                    ),
                    StatsModel(
                        title: "BTC Dominance",
                        volume: marketStats.btcDominance
                    ),
                    StatsModel(
                        title: "Portfolio",
                        volume: portfolioValue.toCurrencyString(code: "$")
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
