//
//  NewsServiceProtocol.swift
//  NewsFeed
//
//  Created by Manish Patidar on 25/05/25.
//
import Foundation

enum NewsFeedError: Error, LocalizedError {
    case invalidURL

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL is invalid."
        }
    }
}

protocol NewsFeedServicing {
    func fetchNews(page: Int, pageSize: Int) async throws -> (articles: [Article], totalResults: Int)
}

struct NewsFeedService: NewsFeedServicing {
    private let networkService: NetworkServicing

    init(networkService: NetworkServicing = NetworkService()) {
        self.networkService = networkService
    }

    func fetchNews(page: Int = 1, pageSize: Int = 10) async throws -> (articles: [Article], totalResults: Int) {
        let request = NewsRequestBuilder()
            .setQuery("iOS")
            .setFromLast(days: 7)
            .setSortBy(.popularity)
            .setPageSize(pageSize)
            .setPage(page)
            .build()
        
        guard let url = request.url else {
            throw NewsFeedError.invalidURL
        }
        
        let response: NewsFeedResponse = try await networkService.request(NewsFeedResponse.self, from: url)
        return (response.articles, response.totalResults)
    }
}
