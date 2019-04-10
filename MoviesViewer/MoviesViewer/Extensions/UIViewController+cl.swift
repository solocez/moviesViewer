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

extension UIViewController: BaseViewController, OverlayHost {
  
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
  
  // https://github.com/agordeev/OverlayViewController
  func showWait(_ message: String?) {
    showOverlay(type: WaitViewController.self, fromStoryboardWithName: "Wait")
  }
  
  //
  func dismissWait() {
    let overlay = UIApplication.getTopMostViewController()?.children.first { (child) -> Bool in
      if let _ = child as? OverlayViewController {
        return true
      }
      return false
    }
    
    (overlay as? OverlayViewController)?.dismissOverlay()
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

