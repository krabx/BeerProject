//
//  BeerViewController.swift
//  BeerProject
//
//  Created by Богдан Радченко on 15.04.2023.
//

import UIKit

class BeerViewController: UIViewController {
    
    var beer: Beer!
    
    private let networkManager = NetworkManager.shared

    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var beerImage: UIImageView!
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = beer.description
        fetchData()
    }
    
    private func fetchData() {
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
