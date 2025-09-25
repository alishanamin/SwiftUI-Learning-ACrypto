import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published private var allCoins: [CoinModel] = []   // 👈 source of truth
    @Published var allCointsList: [CoinModel] = []      // 👈 filtered list for UI
    @Published var portFolioCointsList: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var statsList: [StatsModel] = []

    private let coinService: CoinServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(service: CoinServiceProtocol = CoinService()) {
        self.coinService = service
        addSubscriber()
        fetchCoins()
        fetchMarketStats()
    }

    // MARK: - Subscribers
    private func addSubscriber() {
        $searchText
            .combineLatest($allCoins)  // 👈 use unfiltered source
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { text, coins -> [CoinModel] in
                guard !text.isEmpty else { return coins }
                let lower = text.lowercased()
                return coins.filter {
                    $0.name.lowercased().contains(lower) ||
                    $0.symbol.lowercased().contains(lower)
                }
            }
            .assign(to: \.allCointsList, on: self)
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
                    self?.allCoins = coins           // 👈 update source
                    self?.allCointsList = coins      // 👈 update display (no search yet)
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
                    self?.statsList = [
                        StatsModel(
                            title: "Total Market Cap",
                            volume: data.marketCap,
                            percentage: data.marketCapChangePercentage24hUsd
                        ),
                        StatsModel(
                            title: "Total Market Volume",
                            volume: data.marketVolume
                        ),
                        StatsModel(
                            title: "BTC Dominance",
                            volume: data.btcDominance
                        ),
                        StatsModel(title: "PortFolio", volume: "0.0", percentage: 34)
                    ]
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - Public Actions
    func refresh() {
        fetchCoins()
    }

    func retry() {
        fetchCoins()
    }
}


