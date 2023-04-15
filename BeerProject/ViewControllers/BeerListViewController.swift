//
//  BeerListViewController.swift
//  BeerProject
//
//  Created by Богдан Радченко on 14.04.2023.
//

import UIKit

class BeerListViewController: UITableViewController {
    
    private let networkManager = NetworkManager.shared
    
    private var beers: [Beer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        fetchBeer()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        beers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: indexPath)
        guard let cell = cell as? BeerViewCell else { return UITableViewCell() }
        
        cell.configure(with: beers[indexPath.row])
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let likeButton = UIContextualAction(style: .normal, title: "Like") { _, _, isLike in
            // TODO: likeMethod
            isLike(true)
        }
        
        likeButton.image = UIImage(systemName: "hand.thumbsup")
        
        return UISwipeActionsConfiguration(actions: [likeButton])
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let beerVC = segue.destination as? BeerViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        beerVC.beer = beers[indexPath.row]
    }

}

extension BeerListViewController {
    private func fetchBeer() {
        networkManager.fetchBeer(url: Link.beer.url) { [weak self] result in
            switch result {
            case .success(let beers):
                self?.beers = beers
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
