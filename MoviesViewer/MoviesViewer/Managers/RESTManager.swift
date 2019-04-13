//
//  RESTManager.swift

import Foundation
import Alamofire
import RxSwift

//
protocol RESTManager {
    func nowPlaying(page: Int) -> Single<Movies>
    func downloadPoster(for movie: Movie) -> Single<Movie>
}

//
final class RESTManagerImpl: RESTManager {
    
    private let kItemsPerPage: Int = 20
    private let networkQueue = DispatchQueue(label: "com.solocez.api.network", qos: .background, attributes: .concurrent)

    //
    func nowPlaying(page: Int) -> Single<Movies> {
        return Single<Movies>.create(subscribe: { [unowned self] (observer) in
            guard var url = URL(string: Settings().RESTEndpoint) else {
                observer(.error(AppError(title: R.string.loc.error(), description: "FAILED TO CONSTRUCT URL REQUEST", code: 1)))
                return Disposables.create()
            }
            
            url = url.appending("api_key", value: Settings().apiKey)
            url = url.appending("page", value: String(page))
            
            Log.debug("RETRIEVING MOVIES: \(url.absoluteString)")
            
            Alamofire.request(url, method: .get)
                .validate()
                .responseJSON(queue: self.networkQueue) { response in
                    guard response.result.isSuccess else {
                        observer(.error(AppError(title: R.string.loc.error(), description: "ALL COUNTRIES REQUEST FAILURE", code: 2)))
                        return
                    }
                    
                    guard let data = response.data else {
                        observer(.error(AppError(title: R.string.loc.error(), description: "NO DATA TO DECODE", code: 3)))
                        return
                    }
                    
                    guard let result = try? JSONDecoder().decode(Movies.self, from: data) else {
                        observer(.error(AppError(title: R.string.loc.error(), description: "COULD NOT DECODE RESPONSE", code: 4)))
                        return
                    }
                    
                    observer(.success(result))
            }
            return Disposables.create()
        })
    }
    
    //TODO: is it used?
    func downloadPoster(for movie: Movie) -> Single<Movie> {
        return Single<Movie>.create(subscribe: { [unowned self] (observer) in
            guard let url = self.constructPosterUrl(for: movie) else {
                observer(.error(AppError(title: R.string.loc.error(), description: "FAILED TO CONSTRUCT URL REQUEST", code: 1)))
                return Disposables.create()
            }
            Log.debug("RETRIEVING PHOTO: \(url.absoluteString)")
            Alamofire.request(url, method: .get)
                .validate()
                .responseData(queue: self.networkQueue) { response in
                    guard response.result.isSuccess else {
                        observer(.error(AppError(title: R.string.loc.error(), description: "ALL COUNTRIES REQUEST FAILURE", code: 5)))
                        return
                    }
                    
                    guard let data = response.data else {
                        observer(.error(AppError(title: R.string.loc.error(), description: "NO DATA TO DECODE", code: 6)))
                        return
                    }
                    
//                    let result = Movie(id: movie.id
//                        , title: movie.title
//                        , posterPath: movie.posterPath
//                        , overview: movie.overview
//                        , posterImage: data)
//
//                    observer(.success(result))
                    observer(.success(Movie.fake))
            }
            return Disposables.create()
        })
    }
    
    //
    private func constructPosterUrl(for movie: Movie) -> URL? {
        guard let url = URL(string: Settings().PosterEndpoint + movie.posterPath) else {
            Log.error("FAILED CREATING POSTER URL")
            return nil
        }
        
        return url
    }
}

