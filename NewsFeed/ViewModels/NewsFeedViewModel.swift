//
//  NewsViewModel.swift
//  NewsFeed
//
//  Created by Manish Patidar on 25/05/25.
//
import Foundation

final class NewsFeedViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var showGrid: Bool = false

    private var currentPage = 1
    private let pageSize = 10
    private var totalResults = 0

    //MARK: Dependency
    private let service: NewsFeedServicing

    init(service: NewsFeedServicing = NewsFeedService()) {
        self.service = service
    }

    @MainActor
    func loadNextPage() async {
        guard !isLoading else { return }
        guard totalResults == 0 || articles.count < totalResults else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let (newArticles, total) = try await service.fetchNews(page: currentPage, pageSize: pageSize)
            totalResults = total
            articles.append(contentsOf: newArticles)
            currentPage += 1
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func loadMoreIfNeeded(currentItem: Article) {
        guard !isLoading, let last = articles.last else { return }
        if currentItem.id == last.id {
            Task {
                await loadNextPage()
            }
        }
    }
}
