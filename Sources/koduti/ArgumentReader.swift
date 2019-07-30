//
//  ArgumentReader.swift
//  SwiftShell
//
//  Created by 斉藤 祐輔 on 2019/07/29.
//

import Foundation

public struct ArgumentReader {
    public let args: [String]
    
    public init(args: [String]) {
        self.args = args
    }
    
    var prefix: String? {
        return args.first
    }
    var options: [String] {
        return Array(args.dropFirst())
    }
    var hasOption: Bool {
        return !options.isEmpty
    }
    
    func optionArgument(for option: Generator.OptionType) throws -> [String] {
        let isMatchOption: ((String) -> Bool) = { string in
            return option.shortCut == string || option.rawValue == string
        }
        
        let optionAndArgument = options.reduce([String]()) { result, optionString in
            let isMatch = isMatchOption(optionString)
            if isMatch {
                return result + [optionString]
            }
            
            if optionString.contains("-"), !isMatch {
                return result
            }
            
            if result.count > 0 {
                return result + [optionString]
            }
            
            return result
        }
        
        guard optionAndArgument.count > 1 else {
            throw ServiceError.argumentIsMissing("Not enough argument for kuri \(option.shortCut)")
        }
        
        // Drop -XXXX options
        return Array(optionAndArgument.dropFirst())
    }
}

