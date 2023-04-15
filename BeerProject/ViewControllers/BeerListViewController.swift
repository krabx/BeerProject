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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
