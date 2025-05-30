//
//  ContentView.swift
//  NewsFeed
//
//  Created by Manish Patidar on 25/05/25.
//

import SwiftUI

struct NewsFeedView: View {
    @StateObject private var viewModel = NewsFeedViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.articles.isEmpty {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    contentView
                }
            }
            .navigationTitle("News")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showGrid.toggle()
                    }) {
                        Image(systemName: viewModel.showGrid ? "list.bullet" : "square.grid.2x2")
                    }
                }
            }
        }
        .task {
            await viewModel.loadNextPage()
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if viewModel.showGrid {
            NewsGridView(
                articles: viewModel.articles,
                loadMore: {
                    await viewModel.loadNextPage()
                },
                isLoadingMore: viewModel.isLoading
            )
        } else {
            List {
                ForEach(viewModel.articles) { article in
                    NavigationLink(destination: NewsDetailView(article: article)) {
                        NewsFeedItemView(article: article)
                    }
                    .onAppear {
                        viewModel.loadMoreIfNeeded(currentItem: article)
                    }
                }
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    NewsFeedView()
}
