//
//  WaitPresenter.swift

import UIKit

protocol WaitDataStore {

}

protocol WaitPresenterLogic: WaitDataStore {

}

class WaitPresenter: WaitPresenterLogic {
  
  private weak var view: WaitViewControllerLogic?
  
  public init(view: WaitViewControllerLogic) {
    self.view = view
  }
}
