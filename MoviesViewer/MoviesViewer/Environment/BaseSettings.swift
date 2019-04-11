//
//  BaseSettings.swift

import Foundation
import XCGLogger

protocol BaseSettings {
    
    var appVersion: String { get }
    var logFileName: String { get }
    var logLevel: XCGLogger.Level { get }
    
    var RESTEndpoint: String { get }
    var PosterEndpoint: String { get }
    var apiKey: String { get }
}

extension BaseSettings {
    
    var appVersion: String {
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString"),
            let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") {
            return "Ver. \(version) (\(build))"
        }
        return ""
    }
    
    var logFileName: String {
        get {
            return "moviesviewer.log"
        }
    }
    
    var RESTEndpoint: String {
        get {
            return "http://api.themoviedb.org/3/movie/now_playing"
        }
    }
    
    var PosterEndpoint: String {
        get {
            return "http://image.tmdb.org/t/p/w342"
        }
    }
    
    var apiKey: String {
        get {
            return "ebea8cfca72fdff8d2624ad7bbf78e4c"
        }
    }
}



