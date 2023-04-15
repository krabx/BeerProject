//
//  LikeBeerViewCell.swift
//  BeerProject
//
//  Created by Богдан Радченко on 16.04.2023.
//

import UIKit

final class LikeBeerViewCell: UICollectionViewCell {
    
    private let networkManager = NetworkManager.shared
    
    @IBOutlet var beerImage: UIImageView!
    
    func configure(with beer: Beer) {
        networkManager.fetchData(from: beer.imageURL) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.beerImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
