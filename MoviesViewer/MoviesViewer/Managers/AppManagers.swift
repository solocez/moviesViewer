//
//  AppManagers.swift

import Foundation

//
protocol AppManagers: class {
    var rest: RESTManager { get }
    //  var imgCache: ImageCache { get }
}

//
class AppManagersImpl: AppManagers {
    fileprivate lazy var _rest: RESTManager = RESTManagerImpl()
    //  fileprivate lazy var _imgCache: ImageCache = ImageCacheImpl()
    
    var rest: RESTManager {
        get {
            return _rest
        }
    }
    
    //  var imgCache: ImageCache {
    //    get {
    //      return _imgCache
    //    }
    //  }
}

