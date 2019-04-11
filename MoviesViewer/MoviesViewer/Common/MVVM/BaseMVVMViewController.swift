//
//  BaseMVVMViewController.swift

import UIKit
import RxSwift
import RxCocoa

class BaseMVVMViewController<Model: BaseMVVMViewModel>: UIViewController {
    
    internal var viewModel: Model!
    
    internal let bag = DisposeBag()
    
    deinit {
        Log.debug("DESTROYING \(String(describing: type(of: self)))")
    }
    
    // MARK: Object lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    // MARK: Setup
    
    //
    internal func setupUI() {
    }
    
    //
    internal func setupBindings() {
        viewModel.onError.subscribe(onNext: { [unowned self] (err) in
            self.showError(err)
            }, onError: { (err) in
                Log.error("\(err.localizedDescription)")
        }).disposed(by: bag)
        
        
        viewModel.onWait.subscribe(onNext: { [unowned self] (message) in
            self.showWait(message)
            }, onError: { (err) in
                Log.error("\(err.localizedDescription)")
        }).disposed(by: bag)
        
        
        viewModel.onDismissWait.subscribe(onNext: { [unowned self] _ in
            self.dismissWait()
            }, onError: { (err) in
                Log.error("\(err.localizedDescription)")
        }).disposed(by: bag)
    }
}

