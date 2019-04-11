//
//  AppError.swift
//  Created by Zakhar Sukhanov

import Foundation

struct AppError: LocalizedError {
    var title: String
    var code: Int
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }
    
    private var _description: String
    
    //
    init(title: String, description: String, code: Int) {
        self.title = title
        self._description = description
        self.code = code
    }
    
    //
    init(_ err: Error) {
        self.init(title: R.string.loc.error(), description: err.localizedDescription, code: 1)
    }
}

