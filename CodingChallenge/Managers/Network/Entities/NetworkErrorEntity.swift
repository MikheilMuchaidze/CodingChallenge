//
//  NetworkErrorEntity.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 15.03.25.
//

import Foundation

/// Network error types
enum NetworkErrorEntity: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(Error)
    case decodingFailed(Error)
    case serverError(statusCode: Int, data: Data?)
    case noInternet
    case timeout

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .requestFailed(let error):
            "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            "Invalid server response"
        case .decodingFailed(let error):
            "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let statusCode, _):
            "Server error with status code: \(statusCode)"
        case .noInternet:
            "No internet connection"
        case .timeout:
            "Request timed out"
        }
    }
}
