//
//  AppDelegate.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-10.
//  Copyright © 2019 solocez. All rights reserved.
//

import UIKit
import XCGLogger
import RxSwift

//
var Log: XCGLogger = {
    return XCGLogger.setupSharedLog(identifier: "moviesviewer", logFileName: Settings().logFileName)
} ()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private var appCoordinator: AppCoordinator!
    private let bag = DisposeBag()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.gray]
        
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
            .subscribe()
            .disposed(by: bag)
        
        return true
    }
}


