//
//  UITextField+rx.swift
//  Zakhar Sukhanov

import UIKit
import RxSwift
import RxCocoa

//
public extension Reactive where Base: UITextField {
  
  public var textChange: Observable<String?> {
    return Observable.merge(self.base.rx.observe(String.self, "text"),
                            self.base.rx.controlEvent(.editingChanged).withLatestFrom(self.base.rx.text))
  }

}
