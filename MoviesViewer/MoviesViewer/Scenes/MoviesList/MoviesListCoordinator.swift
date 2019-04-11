//
//  MoviesListCoordinator.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-10.
//

import UIKit
import RxSwift

enum MoviesListCoordinatorResult {
    case language(String)
    case cancel
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
        
        
        //    let cancel = viewModel.didObserverOfSomething.map { _ in CoordinationResult.cancel }
        //    let language = viewModel.didObserverOfSomething.map { CoordinationResult.language($0) }
        //
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable<CoordinationResult>.empty()
    }
}

