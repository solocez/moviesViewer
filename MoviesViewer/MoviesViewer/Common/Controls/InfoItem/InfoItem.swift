//
//  InfoItem.swift
//  MoviesViewer
//
//  Created by Zakhar Sukhanov on 2019-04-13.
//  Copyright © 2019 solocez. All rights reserved.
//

import UIKit

//
protocol InfoItemControl {
    var title: String? { get set }
    var data: String? { get set }
    
    //var backgroundColor: UIColor { set }
}

//
@IBDesignable
final class InfoItem: CustomBaseControl, InfoItemControl {
    
    static let fontSize: CGFloat = 21.0
    
    //
    var title: String? {
        get {
            return titleLbl.text
        }
        set {
            titleLbl.text = newValue
        }
    }
    
    //
    var data: String? {
        get {
            return dataLbl.text
        }
        set {
            dataLbl.text = newValue
        }
    }
    
    //
    override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set {
            super.backgroundColor = newValue
            titleLbl.backgroundColor = newValue
            dataLbl.backgroundColor = newValue
        }
    }
    

    @IBOutlet var view: UIView!
    @IBOutlet weak var containerStack: UIStackView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    
    //
    override func setupControls() {
        super.setupControls()
        
        setupTitleLabel()
        setupDataLabel()
    }
    
    //
    override func prepareForInterfaceBuilder() {
        self.setupControls()
    }
}

//
extension InfoItem {
    //
    private func setupTitleLabel() {
        titleLbl.textColor = UIColor.lightGray
        titleLbl.font = UIFont.systemFont(ofSize: InfoItem.fontSize)
        titleLbl.backgroundColor = backgroundColor
    }
    
    //
    private func setupDataLabel() {
        dataLbl.backgroundColor = backgroundColor
        dataLbl.textColor = UIColor.white
        dataLbl.font = UIFont.boldSystemFont(ofSize: InfoItem.fontSize)
        dataLbl.numberOfLines = 0
    }
}
