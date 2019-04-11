//
//  MoviesListViewController.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-10.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MoviesListViewController: BaseMVVMViewController<MoviesListViewModel>, UICollectionViewDataSource {
    
    private var collectionView: UICollectionView!
    
    // MARK: Object lifecycle
    
    // MARK: Setup
    
    //
    override func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    //
    override func setupBindings() {
        //viewModel.output.movies.drive(collectionView.rx.items)
        viewModel.output.movies.asObservable()
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UICollectionViewCell
                //cell.value?.text = "\(element) @ \(row)"
                return cell
            }
            .disposed(by: bag)
        
    }
}

//
extension MoviesListViewController { // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell(frame: .zero)
    }

}
