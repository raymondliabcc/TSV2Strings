//
//  Decoder.swift
//  TSV2Strings
//
//  Created by Raymond Li on 21/10/2021.
//

import Foundation

class Decoder{
    
    let langs = ["en", "zh-hans", "zh-hant", "ko", "ru", "tr", "es"]
    
    var langDict:Dictionary<String, String> = [:]
    
    func handle(_ tsvString : String, _ savePath : String) -> Bool{
        var path = savePath
        if path.last == "/" {
            path.removeLast()
        }
       let newlines = tsvString.split(whereSeparator: \.isNewline)
        for newline in newlines {
            let words = newline.split(separator: "\t")
            var key:String?
            words.enumerated().forEach{ (index, word) in
                if index == 0 {
                    key = String(word)
                } else {
                    let lang = langs[index - 1]
                    let line = "\"\(key!)\" = \"\(word)\";\n"
                    langDict[lang, default: ""].append(contentsOf:line)
                }
            }
        }
        
        do {
            for (key, value) in langDict {
                let thePath = path.appending("/Exchange/Resources/\(key).lproj/MFJ.strings")
                print("Saving at \(thePath)")
                try value.write(toFile: thePath, atomically: true, encoding: .utf8)
                print("Success")
            }
        } catch {
            fputs("failed: \(error)", stderr)
            return false
        }
        
        return true
    }
    
    
    
}