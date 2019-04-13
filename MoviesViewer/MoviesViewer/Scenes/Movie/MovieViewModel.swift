//
//  MovieViewModel.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-13.
//

import RxSwift
import RxCocoa

//
final class MovieViewModel: BaseMVVMViewModel {
    
    var input: Input!
    var output: Output!
    
    // MARK: - Inputs
    struct Input {
        let observerOfSomething: AnyObserver<String>
    }
    
    // MARK: - Outputs
    struct Output {
        let movie: Movie
        let didObserverOfSomething: Driver<String>
    }
    
    //
    public init(movie: Movie) {
        
        super.init()
        
        let _variableToControl = PublishSubject<String>()
        
        input = Input(observerOfSomething: _variableToControl.asObserver())
        output = Output(movie: movie
            , didObserverOfSomething: _variableToControl.asDriver(onErrorJustReturn: ""))
    }
}

