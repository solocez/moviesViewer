import UIKit
import RxSwift

class BaseMVVMViewModel {
    var onError: Observable<AppError>
    var onWait: Observable<String>
    var onDismissWait: Observable<Void>
    
    internal var bag = DisposeBag()
    
    internal let errorSbj = PublishSubject<AppError>()
    internal let waitSbj = PublishSubject<String>()
    internal let dismissWaitSbj = PublishSubject<Void>()
    
    init() {
        onError = errorSbj.asObserver()
        onWait = waitSbj.asObserver()
        onDismissWait = dismissWaitSbj.asObserver()
    }
    
    deinit {
        //Log.debug("DESTROYING \(String(describing: type(of: self)))")
    }
}

