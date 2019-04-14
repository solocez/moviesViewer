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
        
    }
    
    // MARK: - Outputs
    struct Output {
        let movie: Movie
    }
    
    //
    public init(movie: Movie) {
        super.init()
        
        input = Input()
        output = Output(movie: movie)
    }
}

