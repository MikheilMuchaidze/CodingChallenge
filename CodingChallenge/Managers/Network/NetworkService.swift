//
//  NetworkService.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 15.03.25.
//

import Foundation

protocol NetworkServiceProtocol {
    /// Performs a network request and decodes the response to the specified type
    /// - Parameters:
    ///   - url: The URL for the request
    ///   - method: The HTTP method
    ///   - timeoutInterval: The timeout interval for the request
    /// - Returns: The decoded response of type Tc
    func fetch<T: Decodable>(
        url: URL?,
        method: HTTPMethod
    ) async throws -> T
}

/// Network service client for fetching data from the network
struct NetworkService: NetworkServiceProtocol {
    // MARK: - Private Properties

    private let session: URLSession

    // MARK: - Init

    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Methods

    func fetch<T: Decodable>(
        url: URL?,
        method: HTTPMethod = .get
    ) async throws -> T {
        // Data of response from the request
        let data = try await request(
            url: url,
            method: method
        )

        // Decoding the response data to the specified type
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch {
            print("🛜 Network error: Decoding")
            throw NetworkErrorEntity.decodingFailed(error)
        }
    }

    // MARK: - Private Methods

    private func request(
        url: URL?,
        method: HTTPMethod = .get
    ) async throws -> Data {
        // Checking if url is not nil and throwing an error if it is
        guard let url else {
            print("🛜 Network error: InvalidURL")
            throw NetworkErrorEntity.invalidURL
        }

        // Create URLReques
        var request = URLRequest(url: url)

        // Assign a HTTP method to the request
        request.httpMethod = method.rawValue

        // Block to perform the request and handle errors
        do {
            // Result of performed request
            let (data, response) = try await session.data(for: request)

            // Check if response is a valid and throwing an error if it is not
            guard let httpResponse = response as? HTTPURLResponse else {
                print("🛜 Network error: InvalidResponse")
                throw NetworkErrorEntity.invalidResponse
            }

            let statusCode = httpResponse.statusCode

            // Status code checking
            switch statusCode {
            case 200...299:
                return data
            case 401:
                print("🛜 Network error: UnauthorizedError \(statusCode)")
                throw NetworkErrorEntity.serverError(statusCode: statusCode, data: data)
            case 400...499:
                print("🛜 Network error: BadRequestError \(statusCode)")
                throw NetworkErrorEntity.serverError(statusCode: statusCode, data: data)
            case 500...599:
                print("🛜 Network error: ServerError \(statusCode)")
                throw NetworkErrorEntity.serverError(statusCode: statusCode, data: data)
            default:
                print("🛜 Network error: DefaultServerError")
                throw NetworkErrorEntity.serverError(statusCode: statusCode, data: data)
            }
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                print("🛜 Network error: Cast to NetworkErrorEntity failed, error - notConnectedToInternet")
                throw NetworkErrorEntity.noInternet
            case .timedOut:
                print("🛜 Network error: Cast to NetworkErrorEntity failed, error - timeout")
                throw NetworkErrorEntity.timeout
            default:
                print("🛜 Network error: Cast to NetworkErrorEntity failed, default error - requestFailed")
                throw NetworkErrorEntity.requestFailed(error)
            }
        } catch {
            print("🛜 Network error: Cast to any error object failed")
            throw NetworkErrorEntity.requestFailed(error)
        }
    }
}
