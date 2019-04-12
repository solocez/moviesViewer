//
//  AppManagers.swift

import Foundation

//
protocol AppManagers: class {
    var rest: RESTManager { get }
    var storage: Storage { get }
}

//
class AppManagersImpl: AppManagers {
    private lazy var _rest: RESTManager = RESTManagerImpl()
    private lazy var _storage: Storage = StorageImpl()
    
    var rest: RESTManager {
        get {
            return _rest
        }
    }
    
    var storage: Storage {
        get {
            return _storage
        }
    }
}
