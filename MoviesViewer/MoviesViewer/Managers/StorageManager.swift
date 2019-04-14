//
//  StorageManager.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-12.
//  Copyright © 2019 solocez. All rights reserved.
//

import Foundation
import RealmSwift

//
protocol Storage {
    func addMovies(_ movies: [Movie])
    func remove(_ movie: Movie)
    func fetch(count items: Int, starting from: Int) -> [Movie]
    func moviesCount() -> Int
    func movieAt(_ idx: Int) -> Movie?
}

//
final class StorageImpl: Storage {
    
    //
    init() {
    }
    
    //
    func addMovies(_ movies: [Movie]) {
        let database = try! Realm()
        try! database.write {
            movies.forEach({ (movie) in
                if let item = database.objects(MovieManaged.self).filter("id = %@", movie.id).first {
                    item.voteAverage = movie.voteAverage
                    item.popularity = movie.popularity
                    item.title = movie.title
                    item.posterPath = movie.posterPath
                    item.overview = movie.overview
                    if let newDate = DateFormatter.releaseDateRecord().date(from: movie.releaseDate) {
                        item.releaseDate = newDate
                    }
                } else {
                    let managed = mapToManaged(movie)
                    database.add(managed)
                }
            })
        }
    }
    
    //
    func movieAt(_ idx: Int) -> Movie? {
        let database = try! Realm()
        let movies = database.objects(MovieManaged.self)
        
        guard movies.count > idx else {
            Log.warning("INDEX \(idx) IS OUT OF BOUND \(movies.count)")
            return nil
        }
        
        return mapToUnmanaged(movies[idx])
    }
    
    //
    func remove(_ movie: Movie) {
        let database = try! Realm()
        if let item = database.objects(MovieManaged.self).filter("id = %@", movie.id).first {
            try! database.write {
                database.delete(item)
            }
        } else {
            Log.warning("CAN'T FIND ITEM \(movie.id) \(movie.title)")
        }
    }

    //
    func fetch(count items: Int, starting from: Int) -> [Movie] {
        var result: [Movie] = []
        let database = try! Realm()
        let movies = database.objects(MovieManaged.self)
        
        guard movies.count > from else {
            return []
        }
        
        var idx = 0
        while from + idx < movies.count, idx < items {
            let movieItem = mapToUnmanaged(movies[from + idx])
            result.append(movieItem)
            idx += 1
        }
        
        return result
    }
    
    //
    func moviesCount() -> Int {
        let database = try! Realm()
        return database.objects(MovieManaged.self).count
    }
}

// MARK: Private
extension StorageImpl {
    //
    private func mapToUnmanaged(_ item: MovieManaged) -> Movie {
        let result = Movie(id: item.id
            , voteAverage: item.voteAverage
            , popularity: item.popularity
            , title: item.title
            , posterPath: item.posterPath
            , overview: item.overview
            , releaseDate: DateFormatter.releaseDateRecord().string(from: item.releaseDate)
        )
        return result
    }
    
    //
    private func mapToManaged(_ movie: Movie) -> MovieManaged {
        let result = MovieManaged()
        result.id = movie.id
        result.voteAverage = movie.voteAverage
        result.popularity = movie.popularity
        result.title = movie.title
        result.overview = movie.overview
        result.posterPath = movie.posterPath
        result.releaseDate = DateFormatter.releaseDateRecord().date(from: movie.releaseDate) ?? Date()
        return result
    }
}

//
class MovieManaged: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var voteAverage: Double = 0.0
    @objc dynamic var popularity: Double = 0.0
    @objc dynamic var title: String = ""
    @objc dynamic var posterPath: String = ""
    @objc dynamic var overview: String = ""
    @objc dynamic var releaseDate: Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
