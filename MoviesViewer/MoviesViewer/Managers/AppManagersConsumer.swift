//
//  AppManagersConsumer.swift

import UIKit

//
protocol AppManagersConsumer {
  var appManagers: AppManagers { get }
}

//
fileprivate let appManagersImpl = AppManagersImpl()

//
extension AppManagersConsumer {
  var appManagers: AppManagers {
    get {
      return appManagersImpl
    }
  }
}


