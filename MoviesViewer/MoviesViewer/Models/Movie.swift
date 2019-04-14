//
//  Movie.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-12.
//  Copyright © 2019 solocez. All rights reserved.
//

import Foundation

struct Movies: Decodable {
    let results: [Movie]
    let page: Int
    let totalResults: Int
    
    enum CodingKeys : String, CodingKey {
        case results
        case page
        case totalResults = "total_results"
    }
}

//
struct Movie: Decodable {
    
    public static let fake = Movie(id: -1, voteAverage: 0.0, popularity: 0.0, title: "", posterPath: "", overview: "", releaseDate: "")
    
    let id: Int
    let voteAverage: Double
    let popularity: Double
    let title: String
    let posterPath: String
    let overview: String
    let releaseDate: String
    
    enum CodingKeys : String, CodingKey {
        case id
        case voteAverage = "vote_average"
        case popularity = "popularity"
        case title
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
    }
}

//
extension Movie {
    //
    func posterURL() -> URL? {
        guard let url = URL(string: Settings().PosterEndpoint + posterPath) else {
            Log.error("FAILED CREATING POSTER URL")
            return nil
        }

        return url
    }
}
