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
import AlamofireImage

//
final class MoviesListViewController: BaseMVVMViewController<MoviesListViewModel>
        , UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    private var collectionView: UICollectionView!
    private var indicatorView: UIActivityIndicatorView!
    
    // MARK: Object lifecycle
    
    // MARK: Setup
    
    //
    override func setupUI() {
        title = "Latest Movies"
        view.backgroundColor = Settings().backgroundColor
        setupMoviesCollection()
        setupActivityIndicator()
        startActivity()
    }
    
    //
    override func setupBindings() {
        viewModel.output.reloadData
            .asObservable()
            .take(1)
            .subscribe(onNext: { [unowned self] (_) in
                self.stopActivity()
            }).disposed(by: bag)
        
        viewModel.output.reloadData.drive(onNext: { [unowned self] indexesToReload in
            let tmp = indexesToReload.map { IndexPath(row: $0, section: 0) }
            let toReloadIndexes = self.cellsToReload(intersecting: tmp)
            guard !toReloadIndexes.isEmpty else { return }
            self.collectionView.reloadItems(at: toReloadIndexes)
        }).disposed(by: bag)
        
        viewModel.input.fetchMovies.onNext([])
    }
    
    //
    private func setupMoviesCollection() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width / 2 - 10 , height: height / 3 - 10)
        layout.scrollDirection = .vertical
        //layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Settings().backgroundColor
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.kMovieCellID)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5.0)
        }
        
        collectionView.rx.itemSelected.subscribe(onNext: { [unowned self] (ip) in
            Log.debug("ITEM \(ip.row) SELECTED")
            self.viewModel.input.movieSelected.onNext(ip.row)
        }).disposed(by: bag)
    }
    
    //
    private func setupActivityIndicator() {
        indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.center = view.center
        view.addSubview(indicatorView)
    }
    
    //
    private func startActivity() {
        collectionView.isHidden = true
        indicatorView.startAnimating()
    }
    
    //
    private func stopActivity() {
        indicatorView.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
    }
    
    //
    private func cellsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let ipVisibleCells = collectionView.indexPathsForVisibleItems
        let result = Array(Set(ipVisibleCells).intersection(indexPaths))
        return result
    }
}

// UICollectionViewDataSource
extension MoviesListViewController {
    //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.moviesTotal
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.kMovieCellID, for: indexPath) as! MovieCell
        let movie = viewModel.movieBy(index: indexPath.row)
        cell.setup(movie: movie)
        if nil != movie {
            if let posterURL = movie!.posterURL() {
                cell.posterImage.af_setImage(withURL: posterURL, placeholderImage: R.image.posterPlaceholder())
            }
        }

        return cell
    }
}

// UICollectionViewDataSourcePrefetching
extension MoviesListViewController {
    //
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let indexes = indexPaths.map { $0.row }
        viewModel.input.fetchMovies.onNext(indexes)
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
}
