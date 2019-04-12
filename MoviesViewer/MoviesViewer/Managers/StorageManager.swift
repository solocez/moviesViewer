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
    func addMovie(_ movie: Movie)
    func remove(_ movie: Movie)
    func movies() -> [Movie]
    func searchBy(id: Int) -> Movie?
}

//
class StorageImpl: Storage {
    
    //
    init() {
    }
    
    //
    func addMovie(_ movie: Movie) {
        let database = try! Realm()
        if let item = database.objects(MovieManaged.self).filter("id = %@", movie.id).first {
            try! database.write {
                item.id = movie.id
                item.title = movie.title
                item.posterPath = movie.posterPath
                item.overview = movie.overview
                if let img = movie.posterImage {
                    item.posterImage = img
                }
            }
        } else {
            let managed = mapToManaged(movie)
            try! database.write {
                database.add(managed)
            }
        }
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
    func movies() -> [Movie] {
        var result: [Movie] = []
        let database = try! Realm()
        database.objects(MovieManaged.self).forEach { (managed) in
            result.append(mapToUnmanaged(managed))
        }
        return result
    }
    
    //
    func searchBy(id: Int) -> Movie? {
        let database = try! Realm()
        if let item = database.objects(MovieManaged.self).filter("id = %@", id).first {
            return mapToUnmanaged(item)
        }
        return nil
    }
    
    // MARK: Private
    
    //
    private func mapToUnmanaged(_ item: MovieManaged) -> Movie {
        let result = Movie(id: item.id
            , title: item.title
            , posterPath: item.posterPath
            , overview: item.overview
            , posterImage: item.posterImage
        )
        return result
    }
    
    private func mapToManaged(_ movie: Movie) -> MovieManaged {
        let result = MovieManaged()
        result.id = movie.id
        result.title = movie.title
        result.overview = movie.overview
        result.posterPath = movie.posterPath
        result.posterImage = movie.posterImage ?? Data()
        return result
    }
}

//
class MovieManaged: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var posterPath: String = ""
    @objc dynamic var overview: String = ""
    @objc dynamic var posterImage: Data = Data()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
