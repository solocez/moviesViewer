//
//  MovieCoordinator.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-13.
//

import UIKit
import RxSwift

//
enum MovieCoordinatorResult {
}

//
final class MovieCoordinator: BaseMVVMCoordinator<MovieCoordinatorResult> {
    
    private let navigationViewController: UINavigationController
    
    private let movie: Movie
    
    init(movie: Movie, navigationViewController: UINavigationController) {
        self.navigationViewController = navigationViewController
        self.movie = movie
    }
    
    //
    override func start() -> Observable<CoordinationResult> {
        let viewController = MovieViewController()
        
        let viewModel = MovieViewModel(movie: movie)
        viewController.viewModel = viewModel
        
        navigationViewController.pushViewController(viewController, animated: true)
        
        return Observable.empty()
    }
}

