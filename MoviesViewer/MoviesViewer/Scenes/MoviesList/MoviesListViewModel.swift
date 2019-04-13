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
        
        //
        func movieBy(index: Int) -> Movie? {
            if index < movies.count {
                return movies[index]
            }
            return nil
        }
        
        var didSelectMovie: Driver<Movie>
        
        // TODO: in reality should be a data base - REALM
        fileprivate var movies: [Movie]
    }
    
    private let fetchMoviesSbj = PublishSubject<[Int]>()
    private let movieSelectedSbj = PublishSubject<Int>()
    private var lastFetchedPage: Int = 1
    
    public override init() {
        super.init()
        
        let fetchRequired = fetchMoviesSbj
            .asObservable()
            .filter({ (indexes) -> Bool in
                // Check if new Fetch oparation is required
                if indexes.isEmpty { return true }
                
                let requiredIdx = indexes.first { (idx) -> Bool in
                    idx >= self.output.movies.count
                }
                
                if requiredIdx == nil {
                    return false
                }
                return true
            })
        
        let fetchMoviesObs = fetchRequired.flatMap { [unowned self] _ in
            // Fetch new portion of Movies
            return self.appManagers.rest.nowPlaying(page: self.lastFetchedPage)
                .asObservable()
                .materialize()
            }
            .elements()
            // Serialize Downloaded Movies (with posters) and notify UI
            .flatMap { [unowned self] (movies) -> Single<([Movie],[Int])> in
                Log.debug("RECEIVED \(movies.results.count) OF MOVIES FOR PAGE \(self.lastFetchedPage) TOTAL \(movies.totalResults)")
                
                self.lastFetchedPage += 1
                self.output.moviesTotal = movies.totalResults
                self.output.movies.append(contentsOf: movies.results)
                
                let startIdx = self.output.movies.count - movies.results.count
                let endIdx = startIdx + movies.results.count
                
                return Observable.of((movies.results, (startIdx..<endIdx).map { $0 })).asSingle()
            }
        
        let fetchedMoviesDriver = fetchMoviesObs.map { (_, idx) in
            return idx
        }.asDriver(onErrorJustReturn: [])
        
//        let downloadPostersObs = fetchMoviesObs.flatMap { (movies, indexes) in
//            return self.downloadPosters(for: movies)
//        }
        
        let movieSelectedDriver = movieSelectedSbj.asObservable().map { (index) in
            guard let movie = self.output.movieBy(index: index) else {
                fatalError("NON EXISTING MOVIE FOR INDEX \(index). CHECK LOGIC")
            }
            
            return movie
        }.asDriver(onErrorJustReturn: Movie.fake)
        
        input = Input(fetchMovies: fetchMoviesSbj.asObserver()
            , movieSelected: movieSelectedSbj.asObserver())
        output = Output(moviesTotal: 0
            , reloadData: fetchedMoviesDriver
            , didSelectMovie: movieSelectedDriver
            , movies: [])
    }
    
    // TODO cleanup
    private func downloadPosters(for movies: [Movie]) -> Single<[Movie]> {
//        let tmp: [Observable<Movie>] = movies.map({ [unowned self] (movie) -> Observable<Movie> in
//            self.appManagers.rest.downloadPoster(for: movie)
//                .asObservable()
//        })
//
//        let processedMovies = Observable.concat(tmp).map { (event) -> Movie in
//            return event
//        }.toArray()
//
//        return processedMovies.asSingle()
        
        let tmp: [Observable<Event<Movie>>] = movies.map({ [unowned self] (movie) in
            self.appManagers.rest.downloadPoster(for: movie)
                .asObservable()
                .materialize()
        })
        
        let processedPosters = Observable.concat(tmp).map { (event) -> Movie? in
            Log.debug("PROCESSED \(event.element)")
            return event.element
        }
        
        Observable.concat(tmp).toArray()
        
        let result = Observable.zip(processedPosters, Observable.from(movies)) { (processedMovie, initialMovie) -> Movie in
            Log.debug("POS1 \(processedMovie?.id), POS2 \(initialMovie.id)")
            if nil != processedMovie {
                return processedMovie!
            }
            return initialMovie
            }.toArray()
        
        return result.asSingle()
    }
}




