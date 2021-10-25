//
//  ConsoleIO.swift
//  TSV2Strings
//
//  Created by Raymond Li on 21/10/2021.
//

import Foundation

enum OutputType {
    case error
    case standard
}

class ConsoleIO{
    
    func writeMessage(_ message: String, to: OutputType = .standard) {
        switch to {
        case .standard:
            // 1
            print("\(message)")
        case .error:
            // 2
            fputs("\(message)\n", stderr)
        }
    }
    
    func printUsage() {
        
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        writeMessage("usage:")
        writeMessage("\(executableName) pathToTSV")
    }
    
}
