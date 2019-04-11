//
//  XCGLogger+.swift

import Foundation
import XCGLogger

extension XCGLogger {
    class func setupSharedLog(identifier: String, logFileName: String) -> XCGLogger {
        let log = XCGLogger(identifier: identifier, includeDefaultDestinations: false)
        
        let cacheDirectory: URL = {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return urls[urls.endIndex - 1]
        }()
        
        let logPath = cacheDirectory.appendingPathComponent(logFileName)
        NSLog("\(identifier)'s APP LOG FILE LOCATION: \(logPath.absoluteString)")
        
        log.setup(level: .debug, showLogIdentifier: false, showFunctionName: true, showThreadName: false, showLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: logPath)
        
        // Create a destination for the system console log (via NSLog)
        let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
        
        systemDestination.outputLevel = .debug
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = true
        systemDestination.showThreadName = true
        systemDestination.showLevel = true
        systemDestination.showFileName = true
        systemDestination.showLineNumber = true
        systemDestination.showDate = true
        
        log.add(destination: systemDestination)
        
        
        return log
    }
}

