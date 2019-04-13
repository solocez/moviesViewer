//
//  CustomBaseControl.swift
//
//  Created by Zakhar.Sukhanov
//

import UIKit

class CustomBaseControl: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    xibSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    xibSetup()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  private func xibSetup() {
    guard let contentView = loadViewFromNib() else {
      Log.error("FAILED TO LOAD CUSTOM CONTROL \(String(describing: type(of: self)))")
      return
    }
    
    contentView.frame = bounds
    contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
    addSubview(contentView)
    
    self.setupControls()
  }
  
  private func loadViewFromNib() -> UIView? {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
    
    guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
      return nil
    }
    
    return view
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if !self.bounds.size.equalTo(self.intrinsicContentSize) {
      self.invalidateIntrinsicContentSize()
    }
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    // Must be implemented in child classes
  }
  
  open func setupControls() {
    // Must be implemented in child classes
  }
}
