//
//  MoviesListCoordinator.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-10.
//

import UIKit
import RxSwift

enum MoviesListCoordinatorResult {
}

class MoviesListCoordinator: BaseMVVMCoordinator<MoviesListCoordinatorResult> {
    
    private let window: UIWindow
    
    //
    init(window: UIWindow) {
        self.window = window
    }
    
    //
    override func start() -> Observable<CoordinationResult> {
        let viewController = MoviesListViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let viewModel = MoviesListViewModel()
        viewController.viewModel = viewModel
        
        viewModel.output.didSelectMovie
            .asObservable()
            .subscribe(onNext: { [unowned self] (movie) in
                self.showMovieDetails(movie, nc: navigationController)
            }).disposed(by: bag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable<CoordinationResult>.empty()
    }
    
    private func showMovieDetails(_ movie: Movie, nc: UINavigationController) {
        let movieCoordinator = MovieCoordinator(movie: movie, navigationViewController: nc)
        coordinate(to: movieCoordinator).subscribe(onNext: { (_) in
            //
        }, onError: { (err) in
            Log.error(err)
        }).disposed(by: bag)
    }
}


