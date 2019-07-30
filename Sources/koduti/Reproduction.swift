//
//  Reproduction.swift
//  SwiftShell
//
//  Created by 斉藤 祐輔 on 2019/07/29.
//

import Foundation

struct Reproduction {
    let relativePathFromTemplatesRoot: String
    
    var fileName: String {
        return URL(fileURLWithPath: self.relativePathFromTemplatesRoot).lastPathComponent
    }
    
    var templateType: String {
        guard let templateType = Array(self.relativePathFromTemplatesRoot.components(separatedBy: "/").dropLast()).last else {
            fatalError("Unexpected format file name \(self.fileName)")
        }
        return templateType
    }
    
    var directoriesArray: [String] {
        // remove file name
        return Array(self.relativePathFromTemplatesRoot.components(separatedBy: "/").dropLast())
    }
    
    init(relativePathFromTemplatesRoot: String) {
        self.relativePathFromTemplatesRoot = relativePathFromTemplatesRoot
    }
    
    func getReplacedDirectoryArray(prefix: String, targetName: String) -> [String] {
        return self.directoriesArray.map {
            $0.replaceVariables(prefix: prefix, targetName: targetName)
        }
    }
}
