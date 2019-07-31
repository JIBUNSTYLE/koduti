//
//  Common.swift
//  SwiftShell
//
//  Created by 斉藤 祐輔 on 2019/07/29.
//

import Foundation

let CONFIG_FILE_NAME = "koduti.yml"
let TEMPLATES_DIRECTORY_NAME = "templates"

public func assertionMessage(with function: String = #function, file: String = #file, line: Int = #line, description: String ...) -> String {
    return [
        "function: \(function)"
        , "file: \(file)"
        , "line: \(line)"
        , "description: \(description)"
    ].joined(separator: "\n")
}


public enum KodutiCommands : String {
    case initialize = "init", generate = "gen"
}

enum ConfigProperties: String {
    case Target
    case DefaultTemplateDirectoryPath
    case ProjectRootPath
    case ProjectFileName
    case GenerateRootPath
    case ShouldRemoveLayerNameFromDirectory
}

public enum ServiceError: Error {
    
    case argumentIsMissing(String)
    case xcodeProjectFileNotFound(String)
    case xcodeProjectFileNameIsMissing(String)
    
    case cannotReadYamlFile(String)
    case yamlFileNotFound(String)
    
    case urlError(String)
    case readInputError(String)
    case commandParseError(String)
    case standardInputValidationError(String)
    
    
    public func errorDescription() -> String {
        switch self {
        case .argumentIsMissing(let message):
            return message
        case .xcodeProjectFileNotFound(let message):
            return message
        case .xcodeProjectFileNameIsMissing(let message):
            return message
        case .cannotReadYamlFile(let message):
            return message
        case .yamlFileNotFound(let message):
            return message
            
        case .urlError(let message): return message
        case .readInputError(let message): return message
        case .commandParseError(let message): return message
        case .standardInputValidationError(let message): return message
        
        
        }
    }
}
