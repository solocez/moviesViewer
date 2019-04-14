//
//  URL+mv.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-10.
//  Copyright © 2019 solocez. All rights reserved.
//

import Foundation

//
extension URL {
    
    //
    func appending(_ queryItem: String, value: String?) -> URL {
        guard let value = value else { return absoluteURL }
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        let queryItem = URLQueryItem(name: queryItem, value: value)
        
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        
        return urlComponents.url!
    }
}
