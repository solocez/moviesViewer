//
//  MoviesListViewModel.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-10.
//

import RxSwift
import RxCocoa
import RxDataSources

extension MoviesListViewModel: AppManagersConsumer { }
class MoviesListViewModel: BaseMVVMViewModel {
    
    var input: Input!
    var output: Output!
    
    // MARK: - Inputs
    struct Input {
        let activated: AnyObserver<Void>
    }
    
    // MARK: - Outputs
    struct Output {
        var moviesCount: Driver<Int>
        let movies: Driver<[Movie]>
    }
    
    private let activatedSbj = PublishSubject<Void>()
    private let moviesSbj = PublishSubject<[Movie]>()
    
    public override init() {
        super.init()
        
        let moviesCountDriver = activatedSbj
            .asObservable()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .utility))
            .flatMap { [unowned self] _ in
                return self.appManagers.rest.nowPlaying(page: 0)
            }.map { (movies) in
                return movies.totalResults
            }.asDriver(onErrorJustReturn: 0)
        
        //let dataSources = RxCollectionViewSectionedReloadDataSource<Movie>()
        
        input = Input(activated: activatedSbj.asObserver())
        output = Output(moviesCount: moviesCountDriver
            , movies: moviesSbj.asDriver(onErrorJustReturn: []))
    }
}


