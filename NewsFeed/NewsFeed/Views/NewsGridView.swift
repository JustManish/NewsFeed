//
//  NewsGridView.swift
//  NewsFeed
//
//  Created by Manish Patidar on 25/05/25.
//
import SwiftUI

struct NewsGridView: View {
    let articles: [Article]
    let loadMore: () async -> Void
    let isLoadingMore: Bool

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(articles) { article in
                    NavigationLink(destination: NewsDetailView(article: article)) {
                        VStack(alignment: .leading) {
                            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(height: 120)
                            .cornerRadius(10)

                            Text(article.title)
                                .font(.headline)
                                .lineLimit(2)
                                .padding(.top, 4)

                            Text(article.description ?? "")
                                .font(.subheadline)
                                .lineLimit(2)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 2)
                    }
                    .task {
                        if article == articles.last {
                            await loadMore()
                        }
                    }
                }

                if isLoadingMore {
                    ProgressView()
                        .padding()
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
        }
    }
}
