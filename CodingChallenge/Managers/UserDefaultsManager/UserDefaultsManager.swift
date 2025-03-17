//
//  CacheManager.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 17.03.25.
//

import Foundation

protocol UserDefaultsManagerProtocol {
    func save<T: Encodable>(_ value: T?, forKey key: UserDefaultsKeys)
    func get<T: Decodable>(forKey key: UserDefaultsKeys) -> T?
    func remove(forKey key: UserDefaultsKeys)
    func clear()
}

final class UserDefaultsManager: UserDefaultsManagerProtocol {
    // MARK: - Private Properties

    private let userDefaults: UserDefaults

    // MARK: Init

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - Methods

    func save<T>(
        _ value: T?,
        forKey key: UserDefaultsKeys
    ) where T : Encodable {
        guard let value else { return }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            userDefaults.set(encoded, forKey: key.rawValue)
        }
    }

    func get<T>(forKey key: UserDefaultsKeys) -> T? where T : Decodable {
        if let savedData = userDefaults.data(forKey: key.rawValue) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(T.self, from: savedData) {
                return decoded
            }
        }
        return nil
    }

    func remove(forKey key: UserDefaultsKeys) {
        userDefaults.removeObject(forKey: key.rawValue)
    }

    func clear() {
        let dictionary = userDefaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            userDefaults.removeObject(forKey: key)
        }
    }
}
