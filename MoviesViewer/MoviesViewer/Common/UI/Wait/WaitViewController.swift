//
//  WaitViewController.swift

import UIKit
import RxSwift

protocol WaitViewControllerLogic: class {

}

class WaitViewController: BaseMVPViewController, WaitViewControllerLogic, OverlayViewController {
  
  internal let overlaySize: CGSize? = CGSize(width: UIScreen.main.bounds.width * 0.8,
                                             height: 120.0)
  
  private var presenter: WaitPresenterLogic!

  // MARK: Outlets
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup() {
    presenter = WaitPresenter(view: self)
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: WaitViewControllerLogic implementation
  
  
  // MARK: Actions
  
  
}
