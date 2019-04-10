//
//  StoryboardInitializable.swift

import UIKit

protocol StoryboardMVVMInitializable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardMVVMInitializable where Self: UIViewController {

    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }

    static func initFromStoryboard(name: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
