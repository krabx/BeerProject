//
//  BeerListViewController.swift
//  BeerProject
//
//  Created by Богдан Радченко on 14.04.2023.
//

import UIKit

final class BeerListViewController: UITableViewController {
    
    private let networkManager = NetworkManager.shared
    private let storageManager = StorageManager.shared
    private let searchController = UISearchController(searchResultsController: nil)
    private var beers: [Beer] = []
    private var searchBeer: [Beer] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        searchController.isActive && !searchBarIsEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        setupSearchController()
        fetchBeer()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? searchBeer.count : beers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: indexPath)
        guard let cell = cell as? BeerViewCell else { return UITableViewCell() }
        
        isFiltering
            ? cell.configure(with: searchBeer[indexPath.row])
            : cell.configure(with: beers[indexPath.row])
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let likeButton = UIContextualAction(style: .normal, title: "Like") { [unowned self] _, _, isLike in
            //likeBeer.append(beers[indexPath.row])
            isFiltering
                ? storageManager.save(beer: searchBeer[indexPath.row])
                : storageManager.save(beer: beers[indexPath.row])
            isLike(true)
        }
        
        likeButton.image = UIImage(systemName: "hand.thumbsup")
        
        return UISwipeActionsConfiguration(actions: [likeButton])
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let beerVC = segue.destination as? BeerViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        beerVC.beer = isFiltering ? searchBeer[indexPath.row] : beers[indexPath.row]
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
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension BeerListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterDataBySearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterDataBySearchText(_ searchText: String) {
        searchBeer = beers.filter { beer in
            beer.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}
