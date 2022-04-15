//
//  main.swift
//  TSV2Strings
//
//  Created by Raymond Li on 21/10/2021.
//

import Foundation

let consoleIO = ConsoleIO()
let argCount = CommandLine.argc
//let baseFolder = "/Users/raymondli/workspace/exchange-ios-app/Exchange"
let baseFolder = FileManager.default.currentDirectoryPath
let csvDownloadURL = "https://docs.google.com/spreadsheets/d/1ReGByL4VSdvquccfE97wE2RnRbHRfDUp/gviz/tq?tqx=out:csv&sheet=iOS"

if argCount > 2 {
    consoleIO.writeMessage("Too many arguments", to: .error)
    consoleIO.printUsage()
} else {
    var success: Bool
    if (argCount == 2){
        let argument = CommandLine.arguments[1]
        consoleIO.writeMessage("csv path:\n\(argument)")
        consoleIO.writeMessage("output path:\n\(baseFolder)")
        success = Decoder().handle(argument, URL(fileURLWithPath: baseFolder), true)
    } else {
        consoleIO.writeMessage("csv URL:\n\(csvDownloadURL)")
        consoleIO.writeMessage("output path:\n\(baseFolder)")
        success = Decoder().handle(csvDownloadURL, URL(fileURLWithPath: baseFolder), false)
    }
    
    if success {
        consoleIO.writeMessage("strings files are successfully generated")
    } else {
        consoleIO.writeMessage("strings files generation failed")
    }
}

