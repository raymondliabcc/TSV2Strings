//
//  main.swift
//  TSV2Strings
//
//  Created by Raymond Li on 21/10/2021.
//

import Foundation

let consoleIO = ConsoleIO()
let argCount = CommandLine.argc
let baseFolder = FileManager.default.currentDirectoryPath
let argument = CommandLine.arguments[1]

if argCount != 2 {
    if argCount > 2 {
        consoleIO.writeMessage("Too many arguments", to: .error)
    } else {
        consoleIO.writeMessage("Too few arguments", to: .error)
    }
    consoleIO.printUsage()
} else {
    consoleIO.writeMessage("tsv path:\n\(argument)")
    consoleIO.writeMessage("output path:\n\(baseFolder)")
    let tsv = try? String(contentsOfFile: argument)
    
    let success = Decoder().handle(tsv!, baseFolder)
    
    if success {
        consoleIO.writeMessage("strings files are successfully generated")
    } else {
        consoleIO.writeMessage("strings files generation failed")
    }
}

