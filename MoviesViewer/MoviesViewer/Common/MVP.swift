//
//  MVP.swift
//
//  Created by Zakhar Sukhanov on 2018-12-17.
//  Copyright © 2018 Sukhanov, Zakhar (MGCS). All rights reserved.
//

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

