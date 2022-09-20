//
//  Decoder.swift
//  TSV2Strings
//
//  Created by Raymond Li on 21/10/2021.
//

import Foundation
import SwiftCSV

extension String {
    /// stringToFind must be at least 1 character.
    func countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var count = 0
        var searchRange: Range<String.Index>?
        while let foundRange = range(of: stringToFind, options: [], range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        return count
    }
}

class Decoder{
    
    let langs = ["en", "zh-hans", "zh-hant", "ko", "ru", "tr", "es", "vi", "hi", "pt-PT", "it"]
    
    var langDict:Dictionary<String, String> = [:]
    
    func handle(_ csvPath : String, _ savePath : URL, _ local : Bool) -> Bool{
        var csvFile: CSV?
        
        if (local){
            do {
                csvFile = try CSV(url: URL(fileURLWithPath: csvPath))
            } catch {
                consoleIO.writeMessage("Failed to read file from path \(csvPath): \(error)", to: .error)
            }
        } else {
            do {
                csvFile = try CSV(url: URL(string: csvPath)!)
            } catch {
                consoleIO.writeMessage("Failed to read file from URL \(csvPath): \(error)", to: .error)
            }
        }
        
        if (csvFile == nil){
            return false
        }
        
        for newline in csvFile!.namedRows {
            var keyKey:String = ""
            for (index, langKey) in csvFile!.header.enumerated() {
                if index == 0 {
                    keyKey = langKey
                } else {
                    let lang = langs[index - 1]
                    let key = newline[keyKey]!;
                    let wording = newline[langKey]!
                    let wordingHandled = wording.replacingOccurrences(of: "\"", with: "\\\"")
                    if !wordingHandled.isEmpty {
                        let line = "\"\(key)\" = \"\(wordingHandled)\";\n"
                        langDict[lang, default: ""].append(contentsOf:line)
                    } else {
                        print("key \(key) has empty value in \(lang), ignore")
                    }
                }
            }
        }
        print("Total line: \(csvFile!.namedRows.count)")
        var result = true
        for (key, value) in langDict {
            let thePath = savePath.appendingPathComponent("Exchange/Resources/\(key).lproj/MFJ.strings", isDirectory:false)
            
            var size = winsize();
            let _ = ioctl(STDOUT_FILENO, TIOCGWINSZ, &size);// get window size
            var lineSep = "" // create separator
            let col = size.ws_col < 20 ? 20 : size.ws_col
            for _ in 1...col {
                lineSep += "-"
            }
            print(lineSep)
            print("Saving strings file:\n\(thePath)")
            do {
                try value.write(to: thePath, atomically: true, encoding: .utf8)
                print("Saving Successfully")
            } catch {
                fputs("Failed: \(error)\n", stderr)
                result = false
            }
        }
        
        return result
    }
    
    
    
}
