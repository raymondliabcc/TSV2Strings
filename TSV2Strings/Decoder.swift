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
    
    func handle(_ tsvString : String, _ savePath : URL) -> Bool{
        let newlines = tsvString.split(whereSeparator: \.isNewline)
        for (lineNum, newline) in newlines.enumerated() {
            if (lineNum == 0) {continue} // ignore the first line header
            let words = newline.split(separator: "\t")
            var key:String?
            for (index, word) in words.enumerated() {
                if index == 0 {
                    key = String(word)
                } else {
                    let lang = langs[index - 1]
                    let line = "\"\(key!)\" = \"\(word)\";\n"
                    langDict[lang, default: ""].append(contentsOf:line)
                }
            }
        }
        print("Total line: \(newlines.count)")
        var result = true
        for (key, value) in langDict {
            let thePath = savePath.appendingPathComponent("Exchange/Resources/\(key).lproj/MFJ.strings", isDirectory:false)
            
            var size = winsize();
            let _ = ioctl(STDOUT_FILENO, TIOCGWINSZ, &size);// get window size
            var lineSep = "" // create separator
            for _ in 1...size.ws_col {
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
