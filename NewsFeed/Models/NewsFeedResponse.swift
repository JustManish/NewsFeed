//
//  NewsResponse.swift
//  NewsFeed
//
//  Created by Manish Patidar on 25/05/25.
//
import Foundation

struct NewsFeedResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Identifiable, Decodable {
    let id = UUID()
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

extension Article: Equatable { }
