//
//  BeerViewController.swift
//  BeerProject
//
//  Created by Богдан Радченко on 15.04.2023.
//

import UIKit

class BeerViewController: UIViewController {
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var contributeLabel: UILabel!
    
    @IBOutlet var beerImage: UIImageView!
    
    @IBOutlet var tableView: UITableView!
    
    var beer: Beer!
    
    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        tableView.dataSource = self
        tableView.delegate = self
        fetchData()
    }
    
    @IBAction func noteButtonPressed(_ sender: Any) {
        showAlert()
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
    
    private func setupLabels() {
        navigationItem.title = beer.name
        descriptionLabel.text = beer.description
        contributeLabel.text = beer.contributedBy
        contributeLabel.textAlignment = .center
    }
}

// MARK: - AlertController

extension BeerViewController {
    private func showAlert() {
        let alert = UIAlertController(title: "Note", message: "Add note", preferredStyle: .alert)
        let button = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(button)
        alert.addTextField { textField in
            textField.placeholder = "Enter your note"
        }
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension BeerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Ingredients" : "Food pairing"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0
            ? beer.ingredients.malt.count
            : beer.foodPairing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beerInformation", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        content.text = indexPath.section == 0 ? beer.ingredients.malt[indexPath.row].name : beer.foodPairing[indexPath.row]
        if indexPath.section == 0 {
            content.secondaryText = beer.ingredients.malt[indexPath.row].amount.value.formatted() + " " + beer.ingredients.malt[indexPath.row].amount.unit
        }
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(tableView.numberOfSections)
    }
}
