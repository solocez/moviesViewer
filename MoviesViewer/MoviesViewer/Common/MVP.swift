//
//  MVP.swift

import UIKit
import RxSwift

class BaseMVPViewController: UIViewController {
    
    internal var bag = DisposeBag()
    
    deinit {
        Log.debug("DESTROYING \(String(describing: type(of: self)))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

