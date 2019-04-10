//
//  MoviesListViewModel.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-10.
//

import RxSwift
import RxCocoa

class MoviesListViewModel: BaseMVVMViewModel {
  
  var input: Input!
  var output: Output!
  
  // MARK: - Inputs
  struct Input {
    let observerOfSomething: AnyObserver<String>
  }
  
  // MARK: - Outputs
  struct Output {
    let didObserverOfSomething: Driver<String>
  }
  
  public override init() {
    super.init()
    
    let _variableToControl = PublishSubject<String>()
    
    input = Input(observerOfSomething: _variableToControl.asObserver())
    output = Output(didObserverOfSomething: _variableToControl.asDriver(onErrorJustReturn: ""))
  }
}
