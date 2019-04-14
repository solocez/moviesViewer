//
//  MoviesListViewModel.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-10.
//

import RxSwift
import RxCocoa
import RxSwiftExt

extension MoviesListViewModel: AppManagersConsumer { }
final class MoviesListViewModel: BaseMVVMViewModel {
    
    var input: Input!
    var output: Output!
    
    // MARK: - Inputs
    struct Input {
        let fetchMovies: AnyObserver<[Int]/*indexes of movies*/>
        let movieSelected: AnyObserver<Int/*index*/>
    }
    
    // MARK: - Outputs
    struct Output {
        var moviesTotal: Int
        var reloadData: Driver<[Int]/*indexes of items*/>
        var didSelectMovie: Driver<Movie>
    }
    
    //
    func movieBy(index: Int) -> Movie? {
        return appManagers.storage.movieAt(index)
    }
    
    private let fetchMoviesSbj = PublishSubject<[Int]>()
    private let movieSelectedSbj = PublishSubject<Int>()
    private var lastFetchedPage: Int = 1
    
    public override init() {
        super.init()
        
        input = Input(fetchMovies: fetchMoviesSbj.asObserver()
            , movieSelected: movieSelectedSbj.asObserver())
        
        output = Output(moviesTotal: 0
            , reloadData: setupFetchMovies()
            , didSelectMovie: setupMovieSelected())
    }
}

// Private
extension MoviesListViewModel {
    //
    private func setupMovieSelected() -> Driver<Movie> {
        return movieSelectedSbj.asObservable().map { [unowned self] (index) in
            guard let movie = self.appManagers.storage.movieAt(index) else {
                fatalError("NON EXISTING MOVIE FOR INDEX \(index). CHECK LOGIC")
            }
            
            return movie
            }.asDriver(onErrorJustReturn: Movie.fake)
    }
    
    //
    private func setupFetchMovies() -> Driver<[Int]> {
        let fetchRequired = fetchMoviesSbj
            .asObservable()
            .filter({ (indexes) -> Bool in
                // Check if new Fetch oparation is required
                if indexes.isEmpty { return true }
                
                let requiredIdx = indexes.first { (idx) -> Bool in
                    idx >= self.appManagers.storage.moviesCount()
                }
                
                if requiredIdx == nil {
                    return false
                }
                return true
            })
        
        let fetchFromWebResultObs = fetchRequired.flatMap { [unowned self] _ -> Observable<Event<Movies>> in
            // Fetch new portion of Movies
            return self.appManagers.rest.nowPlaying(page: self.lastFetchedPage)
                .asObservable()
                .materialize()
            }.share()
        
        let fetchOK = fetchFromWebResultObs.elements().map { (movies) -> [Int] in
            Log.debug("RECEIVED \(movies.results.count) OF MOVIES FOR PAGE \(self.lastFetchedPage) TOTAL \(movies.totalResults)")
            
            self.lastFetchedPage += 1
            self.output.moviesTotal = movies.totalResults
            self.appManagers.storage.addMovies(movies.results)
            
            let startIdx = self.appManagers.storage.moviesCount() - movies.results.count
            let endIdx = startIdx + movies.results.count
            return (startIdx..<endIdx).map { $0 }
        }
        
        let fetchFailed = fetchFromWebResultObs.errors().map { [unowned self] (err) -> [Movie] in
            Log.warning("FAILED TO FETCH FROM WEB: \(err.localizedDescription). \nFETCHING FROM DB.")
            return self.appManagers.storage.fetch(count: Settings().itemsPerPage
                , starting: Settings().itemsPerPage * self.lastFetchedPage)
            }.map { [unowned self] (movies) -> [Int] in
                Log.debug("FETCHED \(movies.count) OF MOVIES FOR PAGE \(self.lastFetchedPage) FROM STORAGE")
                
                // Pagination is "1" based - not zero based.
                // That's why "aligning" here subtracting one
                let startIdx = (self.lastFetchedPage - 1) * Settings().itemsPerPage
                let endIdx = startIdx + movies.count
                
                if movies.count == Settings().itemsPerPage {
                    self.lastFetchedPage += 1
                }
                self.output.moviesTotal = self.appManagers.storage.moviesCount()
                
                return (startIdx..<endIdx).map { $0 }
        }
        
        return Observable.of(fetchOK, fetchFailed).merge().asDriver(onErrorJustReturn: [])
    }
}

