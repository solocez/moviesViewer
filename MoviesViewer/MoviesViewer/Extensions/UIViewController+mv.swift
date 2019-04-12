//
//  UIViewController+.swift

import UIKit
import RxSwift

protocol BaseViewController: class {
    func showMessage(_ message: String?) -> Single<Void>
    func showWait(_ message: String?)
    func dismissWait()
    func showError(_ appError: AppError) -> Single<Void>
}

extension UIViewController: BaseViewController {
    
    @discardableResult
    func showMessage(_ message: String?) -> Single<Void> {
        return Single<Void>.create(subscribe: { [unowned self] (observer) in
            let alert = UIAlertController(title: R.string.loc.alert(), message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.loc.ok(), style: .default, handler: { (action) in
                observer(.success(Void()))
            }))
            self.present(alert, animated: true, completion: nil)
            
            return Disposables.create()
        })
    }
    
    //
    func showWait(_ message: String?) {
        fatalError("Not implemented")
    }
    
    //
    func dismissWait() {
        fatalError("Not implemented")
    }
    
    @discardableResult
    func showError(_ appError: AppError) -> Single<Void> {
        return Single<Void>.create(subscribe: { [unowned self] (observer) in
            let alert = UIAlertController(title: R.string.loc.error(), message: appError.errorDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: R.string.loc.ok(), style: .default, handler: { (action) in
                observer(.success(Void()))
            }))
            self.present(alert, animated: true, completion: nil)
            
            return Disposables.create()
        })
    }
}
