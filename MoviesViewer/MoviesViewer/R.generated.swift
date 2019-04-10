//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 3 storyboards.
  struct storyboard {
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    /// Storyboard `MoviesList`.
    static let moviesList = _R.storyboard.moviesList()
    /// Storyboard `Wait`.
    static let wait = _R.storyboard.wait()
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    /// `UIStoryboard(name: "MoviesList", bundle: ...)`
    static func moviesList(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.moviesList)
    }
    
    /// `UIStoryboard(name: "Wait", bundle: ...)`
    static func wait(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.wait)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 1 localization tables.
  struct string {
    /// This `R.string.loc` struct is generated, and contains static references to 8 localization keys.
    struct loc {
      /// Value: Alert
      static let alert = Rswift.StringResource(key: "alert", tableName: "Loc", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Cancel
      static let cancel = Rswift.StringResource(key: "cancel", tableName: "Loc", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Done
      static let done = Rswift.StringResource(key: "done", tableName: "Loc", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Downloading items
      static let downloadingItems = Rswift.StringResource(key: "downloading.items", tableName: "Loc", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Enter Title here
      static let enterTitleHere = Rswift.StringResource(key: "enter.title.here", tableName: "Loc", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Error
      static let error = Rswift.StringResource(key: "error", tableName: "Loc", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Ok
      static let ok = Rswift.StringResource(key: "ok", tableName: "Loc", bundle: R.hostingBundle, locales: [], comment: nil)
      /// Value: Unknown
      static let unknown = Rswift.StringResource(key: "unknown", tableName: "Loc", bundle: R.hostingBundle, locales: [], comment: nil)
      
      /// Value: Alert
      static func alert(_: Void = ()) -> String {
        return NSLocalizedString("alert", tableName: "Loc", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Cancel
      static func cancel(_: Void = ()) -> String {
        return NSLocalizedString("cancel", tableName: "Loc", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Done
      static func done(_: Void = ()) -> String {
        return NSLocalizedString("done", tableName: "Loc", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Downloading items
      static func downloadingItems(_: Void = ()) -> String {
        return NSLocalizedString("downloading.items", tableName: "Loc", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Enter Title here
      static func enterTitleHere(_: Void = ()) -> String {
        return NSLocalizedString("enter.title.here", tableName: "Loc", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Error
      static func error(_: Void = ()) -> String {
        return NSLocalizedString("error", tableName: "Loc", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Ok
      static func ok(_: Void = ()) -> String {
        return NSLocalizedString("ok", tableName: "Loc", bundle: R.hostingBundle, comment: "")
      }
      
      /// Value: Unknown
      static func unknown(_: Void = ()) -> String {
        return NSLocalizedString("unknown", tableName: "Loc", bundle: R.hostingBundle, comment: "")
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try main.validate()
      try moviesList.validate()
      try wait.validate()
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = ViewController
      
      let bundle = R.hostingBundle
      let name = "Main"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct moviesList: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "MoviesList"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct wait: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "Wait"
      let waitViewController = StoryboardViewControllerResource<WaitViewController>(identifier: "WaitViewController")
      
      func waitViewController(_: Void = ()) -> WaitViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: waitViewController)
      }
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.wait().waitViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'waitViewController' could not be loaded from storyboard 'Wait' as 'WaitViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
