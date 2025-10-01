//
//  CoinDetailViewModel.swift
//  ACrypto
//
//  Created by ALI SHAN Muhammad Amin on 01/10/2025.
//

import Foundation
import Combine

class CoinDetailViewModel: ObservableObject {
    @Published private(set) var overViewStats: [StatisticModel] = []
    @Published private(set) var additionalOverViewStats: [StatisticModel] = []
    @Published private(set) var coin: CoinModel
    @Published private(set) var coinDetailModel: CoinDetailModel?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    private let coinService: CoinServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel, service: CoinServiceProtocol = CoinService()) {
        self.coin = coin
        self.coinService = service
        getCoinDetail(coinID: coin.id)
        addSubscriber()
    }
    
    // MARK: - Subscribers
    private func addSubscriber() {
        
        $coinDetailModel
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] (returnedArrays) in
                self?.overViewStats = returnedArrays.overview
                self?.additionalOverViewStats = returnedArrays.additional
            }
            .store(in: &cancellables)
        
    }
    
    // MARK: - Networking
    private func getCoinDetail(coinID: String) {
        isLoading = true
        errorMessage = nil
        
        coinService.getCoinDetails(coinID: coinID)
            .receive(on: DispatchQueue.main)
        
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] coinDetail in
                guard let self else { return }
                self.coinDetailModel = coinDetail
            
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(
        coinDetailModel: CoinDetailModel?,
        coinModel: CoinModel
    ) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        
        return (overviewArray, additionalArray)
    }
    
    private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
        let price = coinModel.currentPrice.toCurrencyStringFormat(code: "$")
        let pricePercentChange = coinModel.priceChangePercentage24h
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24h
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        return [priceStat, marketCapStat, rankStat, volumeStat]
    }
    
    private func createAdditionalArray(
        coinDetailModel: CoinDetailModel?,
        coinModel: CoinModel
    ) -> [StatisticModel] {
        
        let high = coinModel.high24h?.toCurrencyStringFormat(code: "$") ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24h?.toCurrencyStringFormat(code: "$") ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24h?.toCurrencyStringFormat(code: "$") ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24h
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24h?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24h
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "N/A" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "N?A"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        return [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat]
    }
}

