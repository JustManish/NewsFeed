//
//  NewsEndpoint.swift
//  NewsFeed
//
//  Created by Manish Patidar on 25/05/25.
//
import Foundation

enum Endpoint: String {
    case everything = "/v2/everything"
    case topHeadlines = "/v2/top-headlines"
    case sources = "/v2/sources"
}

struct NewsRequest {
    let url: URL?

    init(path: Endpoint, queryItems: [URLQueryItem]) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = path.rawValue

        var items = queryItems
        if let apiKey = Self.apiKey {
            items.append(.init(name: "apiKey", value: apiKey))
        }
        components.queryItems = items
        self.url = components.url
    }

    private static var apiKey: String? {
        return Bundle.main.object(forInfoDictionaryKey: "NewsAPIKey") as? String
    }
}

final class NewsRequestBuilder {
    private var path: Endpoint = .everything
    private var queryItems: [URLQueryItem] = []

    func setPath(_ path: Endpoint) -> Self {
        self.path = path
        return self
    }

    func setQuery(_ query: String) -> Self {
        queryItems.append(.init(name: "q", value: query))
        return self
    }

    func setFrom(_ date: Date) -> Self {
        queryItems.append(.init(name: "from", value: date.format()))
        return self
    }

    func setTo(_ date: Date) -> Self {
        queryItems.append(.init(name: "to", value: date.format()))
        return self
    }
    
    func setFromLast(days: Int) -> Self {
        let fromDate = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return setFrom(fromDate)
    }
    
    func setFromLast(weeks: Int) -> Self {
        let fromDate = Calendar.current.date(byAdding: .day, value: -(weeks * 7), to: Date()) ?? Date()
        return setFrom(fromDate)
    }
    
    func setFromLast(months: Int) -> Self {
        let fromDate = Calendar.current.date(byAdding: .month, value: -months, to: Date()) ?? Date()
        return setFrom(fromDate)
    }
    
    func setDateRange(from fromDate: Date, to toDate: Date = Date()) -> Self {
        return setFrom(fromDate).setTo(toDate)
    }

    func setSortBy(_ sort: SortOption) -> Self {
        queryItems.append(.init(name: "sortBy", value: sort.rawValue))
        return self
    }

    func setPageSize(_ size: Int) -> Self {
        queryItems.append(.init(name: "pageSize", value: "\(size)"))
        return self
    }

    func setPage(_ page: Int) -> Self {
        queryItems.append(.init(name: "page", value: "\(page)"))
        return self
    }

    func build() -> NewsRequest {
        return NewsRequest(path: path, queryItems: queryItems)
    }
}

enum SortOption: String {
    case relevancy
    case popularity
    case publishedAt
}

extension Date {
    func format(_ format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: self)
    }
}
