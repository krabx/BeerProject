//
//  StorageManager.swift
//  BeerProject
//
//  Created by Богдан Радченко on 16.04.2023.
//

import Foundation

final class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    
    private let key = "likeBeer"
    
    private init() {}
    
    func save(beer: Beer) {
        var likeBeers = fetchLike()
        likeBeers.append(beer)
        
        guard let data = try? JSONEncoder().encode(likeBeers) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func fetchLike() -> [Beer] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        guard let likeBeers = try? JSONDecoder().decode([Beer].self, from: data) else {
            print("error")
            return []
        }
        return likeBeers
    }
    
    func delete(at index: Int) {
        var likeBeers = fetchLike()
        likeBeers.remove(at: index)
        guard let data = try? JSONEncoder().encode(likeBeers) else { return }
        userDefaults.set(data, forKey: key)
    }
}
