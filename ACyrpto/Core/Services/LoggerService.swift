import Foundation
import os

enum LogLevel {
    case debug, info, warning, error, fault
    
    var emoji: String {
        switch self {
        case .debug: return "🐞"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .error: return "❌"
        case .fault: return "💀"
        }
    }
}

final class LoggerService {
    static let shared = LoggerService()
    private init() {}
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.myapp", category: "general")
    
    private func log(_ level: LogLevel, _ message: String,
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line) {
        
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "\(level.emoji) [\(fileName):\(line) \(function)] \(message)"
        
        switch level {
        case .debug:
            logger.debug("\(logMessage, privacy: .public)")
        case .info:
            logger.info("\(logMessage, privacy: .public)")
        case .warning:
            logger.warning("\(logMessage, privacy: .public)")
        case .error:
            logger.error("\(logMessage, privacy: .public)")
        case .fault:
            logger.fault("\(logMessage, privacy: .public)")
        }
    }
    
    // MARK: - Public methods
    func d(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.debug, message, file: file, function: function, line: line)
    }
    
    func i(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.info, message, file: file, function: function, line: line)
    }
    
    func w(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.warning, message, file: file, function: function, line: line)
    }
    
    func e(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.error, message, file: file, function: function, line: line)
    }
    
    func f(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(.fault, message, file: file, function: function, line: line)
    }
}


