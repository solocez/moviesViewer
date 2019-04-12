//
//  MoviesListViewModel.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-10.
//

import RxSwift
import RxCocoa

extension MoviesListViewModel: AppManagersConsumer { }
class MoviesListViewModel: BaseMVVMViewModel {
    
    var input: Input!
    var output: Output!
    
    // MARK: - Inputs
    struct Input {
        let fetchMovies: AnyObserver<[Int]/*indexes of movies*/>
    }
    
    // MARK: - Outputs
    struct Output {
        var moviesTotal: Int
        var reloadData: Driver<[Int]>
        
        //
        func movieBy(index: Int) -> Movie? {
            if index < movies.count {
                return movies[index]
            }
            return nil
        }
        
        fileprivate var movies: [Movie]
    }
    
    private let fetchMoviesSbj = PublishSubject<[Int]>()
    private var lastFetchedPage: Int = 1
    
    public override init() {
        super.init()
        
        let fetchRequired = fetchMoviesSbj
            .asObservable()
            .filter({ (indexes) -> Bool in
                if indexes.isEmpty { return true }
                
                let requiredIdx = indexes.first { (idx) -> Bool in
                    idx >= self.output.movies.count
                }
                
                if requiredIdx == nil {
                    return false
                }
                return true
            })
        
        let reloadDriver = fetchRequired.flatMap { [unowned self] _ in
                return self.appManagers.rest.nowPlaying(page: self.lastFetchedPage)
            }.map { [unowned self] (movies) -> [Int] in
                
                Log.debug("RECEIVED \(movies.results.count) OF MOVIES FOR PAGE \(self.lastFetchedPage)")
                
                self.lastFetchedPage += 1
                self.output.moviesTotal = movies.totalResults
                self.output.movies.append(contentsOf: movies.results)
                
                let startIdx = self.output.movies.count - movies.results.count
                let endIdx = startIdx + movies.results.count
                return (startIdx..<endIdx).map { $0 }
            }.asDriver(onErrorJustReturn: [])

        input = Input(fetchMovies: fetchMoviesSbj.asObserver())
        output = Output(moviesTotal: 0, reloadData: reloadDriver, movies: [])
    }
}


