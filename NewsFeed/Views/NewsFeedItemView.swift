//
//  NewsFeedItemView.swift
//  NewsFeed
//
//  Created by Manish Patidar on 25/05/25.
//
import SwiftUI

struct NewsFeedItemView: View {
    let article: Article

    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 100, height: 80)
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                Text(article.description ?? "")
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
            }
        }
    }
}
