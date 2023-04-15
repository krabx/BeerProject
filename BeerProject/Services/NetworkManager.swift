//
//  NetworkManager.swift
//  BeerProject
//
//  Created by Богдан Радченко on 12.04.2023.
//

import Foundation

enum Link {
    case beer
    
    var url: String {
        switch self {
        case .beer:
            return "https://api.punkapi.com/v2/beers/"
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    enum NetworkError: Error {
        case failURL
        case failData
        case failDecode
    }
    
    func fetchBeer(url: String, completion: @escaping (Result<[Beer], NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.failURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.failData))
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()

            do {
                let beerModel = try decoder.decode([Beer].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(beerModel))
                }
            } catch {
                completion(.failure(.failDecode))
            }
        }.resume()
    }
    
    func fetchData(from url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.failURL))
            return
        }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.failData))
                return
            }
    
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
        
    }
}
