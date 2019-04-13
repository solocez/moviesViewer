//
//  AppCoordinator.swift

import UIKit
import RxSwift

//
final class AppCoordinator: BaseMVVMCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let mainScrn = MoviesListCoordinator(window: window)
        return coordinate(to: mainScrn).flatMap({ (_) in
            return Observable<Void>.just(Void())
        })
    }
}
