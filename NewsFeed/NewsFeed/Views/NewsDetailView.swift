//
//  NewsDetailView.swift
//  NewsFeed
//
//  Created by Manish Patidar on 25/05/25.
//
import SwiftUI

struct NewsDetailView: View {
    let article: Article

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                }

                Text(article.title)
                    .font(.title)
                    .fontWeight(.bold)

                Text(article.content ?? article.description ?? "")
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
