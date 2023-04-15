//
//  BeerViewCell.swift
//  BeerProject
//
//  Created by Богдан Радченко on 15.04.2023.
//

import UIKit

final class BeerViewCell: UITableViewCell {
    
    private let networkManager = NetworkManager.shared
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var noteLabel: UILabel!
    
    @IBOutlet var beerImage: UIImageView! {
        didSet {
            beerImage.layer.cornerRadius = beerImage.frame.width / 2
        }
    }
    
    func configure(with beer: Beer) {
        nameLabel.text = beer.name
        
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
