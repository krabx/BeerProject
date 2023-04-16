//
//  LikeBeerCollectionViewController.swift
//  BeerProject
//
//  Created by Богдан Радченко on 16.04.2023.
//

import UIKit

final class LikeBeerCollectionViewController: UICollectionViewController {
    
    private let storageManager = StorageManager.shared
    
    private var likeBeers: [Beer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLikeBeers()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        likeBeers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likeBeer", for: indexPath)
        guard let cell = cell as? LikeBeerViewCell else { return UICollectionViewCell() }
        cell.configure(with: likeBeers[indexPath.row])
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        storageManager.delete(at: indexPath.row)
        setLikeBeers()
        collectionView.deleteItems(at: [indexPath])
        collectionView.reloadSections(IndexSet(integer: indexPath.section))
        print(indexPath, indexPath.section)
    }
    
    private func setLikeBeers() {
        likeBeers = storageManager.fetchLike()
    }

}

extension LikeBeerCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.window?.windowScene?.screen.bounds.width ?? 400 - 32, height: 400)
    }
}
