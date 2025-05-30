//
//  APIClientProtocol.swift
//  NewsFeed
//
//  Created by Manish Patidar on 25/05/25.
//
import Foundation

protocol NetworkServicing {
    func request<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T
}

struct NetworkService: NetworkServicing {
    func request<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
