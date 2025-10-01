//
//  CoinDetailModel.swift
//  ACyrpto
//
//  Created by ALI SHAN Muhammad Amin on 01/10/2025.
//

import Foundation

struct CoinDetailModel: Codable, Identifiable, Sendable {
    let id: String
    let symbol: String
    let name: String
    let webSlug: String?
    let assetPlatformId: String?
    let platforms: [String: String]?
    let detailPlatforms: [String: DetailPlatform]?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let categories: [String]?
    let previewListing: Bool?
    let publicNotice: String?
    let additionalNotices: [String]?
    let description: Description?
    let links: Links?
    let image: CoinImage?
    let countryOrigin: String?
    let genesisDate: String?
    let sentimentVotesUpPercentage: Double?
    let sentimentVotesDownPercentage: Double?
    let watchlistPortfolioUsers: Int?
    let marketCapRank: Int?
    let statusUpdates: [StatusUpdate]?
    let lastUpdated: String?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, platforms, categories, description, links, image, statusUpdates
        case webSlug = "web_slug"
        case assetPlatformId = "asset_platform_id"
        case detailPlatforms = "detail_platforms"
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
        case previewListing = "preview_listing"
        case publicNotice = "public_notice"
        case additionalNotices = "additional_notices"
        case countryOrigin = "country_origin"
        case genesisDate = "genesis_date"
        case sentimentVotesUpPercentage = "sentiment_votes_up_percentage"
        case sentimentVotesDownPercentage = "sentiment_votes_down_percentage"
        case watchlistPortfolioUsers = "watchlist_portfolio_users"
        case marketCapRank = "market_cap_rank"
        case lastUpdated = "last_updated"
    }
}

// MARK: - DetailPlatform
struct DetailPlatform: Codable {
    let decimalPlace: Int?
    let contractAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case decimalPlace = "decimal_place"
        case contractAddress = "contract_address"
    }
}

// MARK: - Description
struct Description: Codable {
    let en: String?
}

// MARK: - Links
struct Links: Codable {
    let homepage: [String]?
    let whitepaper: String?
    let blockchainSite: [String]?
    let officialForumURL: [String]?
    let chatURL: [String]?
    let announcementURL: [String]?
    let snapshotURL: String?
    let twitterScreenName: String?
    let facebookUsername: String?
    let bitcointalkThreadIdentifier: String?
    let telegramChannelIdentifier: String?
    let subredditURL: String?
    let reposURL: ReposURL?
    
    enum CodingKeys: String, CodingKey {
        case homepage, whitepaper, reposURL
        case blockchainSite = "blockchain_site"
        case officialForumURL = "official_forum_url"
        case chatURL = "chat_url"
        case announcementURL = "announcement_url"
        case snapshotURL = "snapshot_url"
        case twitterScreenName = "twitter_screen_name"
        case facebookUsername = "facebook_username"
        case bitcointalkThreadIdentifier = "bitcointalk_thread_identifier"
        case telegramChannelIdentifier = "telegram_channel_identifier"
        case subredditURL = "subreddit_url"
    }
}

// MARK: - ReposURL
struct ReposURL: Codable {
    let github: [String]?
    let bitbucket: [String]?
}

// MARK: - CoinImage
struct CoinImage: Codable {
    let thumb: String?
    let small: String?
    let large: String?
}

// MARK: - StatusUpdate
struct StatusUpdate: Codable {
    let description: String?
    let category: String?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case description, category
        case createdAt = "created_at"
    }
}

