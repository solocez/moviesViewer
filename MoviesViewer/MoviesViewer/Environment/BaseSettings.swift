//
//  BaseSettings.swift

import Foundation
//imsport XCGLogger

protocol BaseSettings {
  
  var appVersion: String { get }
  var logFileName: String { get }
  //var logLevel: XCGLogger.Level { get }
  
  var mimimumTitleLength: Int { get }
  var RESTEndpoint: String { get }
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
      return "https://jsonplaceholder.typicode.com"
    }
  }
  
  var mimimumTitleLength: Int {
    get {
      return 8
    }
  }
}

