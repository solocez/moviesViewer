//
//  DateFormatter+mv.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-13.
//  Copyright © 2019 solocez. All rights reserved.
//

import Foundation

//
extension DateFormatter {
    //
    static func releaseDateRecord() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter
    }
    
    //
    static func releaseDateFormat() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        return formatter
    }
}
