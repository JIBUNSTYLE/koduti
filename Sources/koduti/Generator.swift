//
//  Generator.swift
//  SwiftShell
//
//  Created by 斉藤 祐輔 on 2019/07/29.
//

import Foundation
import SwiftShell
import Yaml
import XcodeProject

public struct Generator {
    let fileManager = Files
    
    public let argument: ArgumentReader
    public let yaml: Yaml
    
    public init(argument: ArgumentReader, yaml: Yaml) {
        self.argument = argument
        self.yaml = yaml
    }
    
    fileprivate var reproductions: [Reproduction] = []
    
    public mutating func execute() throws {
        let yamlReader = YamlReader<String>(yaml: yaml)
        let templatesRoot = yamlReader.value(for: .DefaultTemplateDirectoryPath)
        self.regenerateReproductions(for: templatesRoot)
        
        guard let prefix = argument.prefix else {
            throw ServiceError.argumentIsMissing("Should input generate entity name")
        }
        
        let offsetAndOption = try argument.options.enumerated()
            .filter { $1.contains("-") }
            .map { (offset: $0, option: try OptionType(shortCut: $1)) }
            .sorted { $0.option.hashValue > $1.option.hashValue }
        
        try offsetAndOption.forEach { offset, option in
            try setupForExec(with: option)
        }
        
        try generate(with: prefix, for: reproductions, and: templatesRoot)
    }
    
    mutating func regenerateReproductions(for templateDirectoryName: String) {
        self.reproductions = main.run(bash: "find \(templateDirectoryName) -name '*.swift' -o -name '*.xib' -o -name '*.storyboard'")
            .stdout
            .components(separatedBy: "\n")
            .filter { !$0.isEmpty }
            .map { templateDirectoryFullPath -> String in
                // remove from template directory
                // and template directory name.
                guard let bound = templateDirectoryFullPath.range(of: templateDirectoryName)?.upperBound else {
                    fatalError(
                        "Unexpected path when decide for read template directory path. info: headPath: \(templateDirectoryName), templateDirectoryFullPath: \(templateDirectoryFullPath)"
                    )
                }
                let subString = templateDirectoryFullPath[bound...]
                return String(subString)
            }
            .map( Reproduction.init )
    }
    
}

extension Generator {
    enum OptionType: String {
        case templateSpecify
        case specify
//        case interactive
        
        init(shortCut: String) throws {
            switch shortCut {
            case OptionType.templateSpecify.shortCut:
                self = .templateSpecify
            case OptionType.specify.shortCut:
                self = .specify
//            case OptionType.interactive.shortCut:
//                self = .interactive
            default:
                throw ServiceError.argumentIsMissing(assertionMessage(description: "Unknown option for \(shortCut)"))
            }
        }
        
        var shortCut: String {
            switch self {
            case .templateSpecify:
                return "-t"
            case .specify:
                return "-s"
//            case .interactive:
//                return "-i"
            }
        }
    }
    
    fileprivate mutating func setupForExec(with option: Generator.OptionType) throws {
        switch option {
        case .templateSpecify:
            let templatesRoot = try self.executeForTemplateSpecify()
            self.regenerateReproductions(for: templatesRoot)
            
        case .specify:
            self.reproductions = try self.generateComponentsForSpecity()
            
//        case .interactive:
//            reproductions = try self.generateComponentsForInteractive()
        }
    }
    
//    fileprivate func generateComponentsForInteractive() throws -> [Reproduction] {
//        let answeredComponents = try reproductions.filter {
//            let message = "Do you want to \($0.componentType) [y/N]"
//            let answer = try CommandInput.waitStandardInputWhileInvalid(
//                with: message,
//                validation: { (input) -> Bool in
//                    return input == "y" || input == "Y" || input == "n" || input == "N"
//            })
//            return answer == "y" || answer == "Y"
//        }
//
//        return answeredComponents
//    }
    
    fileprivate func generateComponentsForSpecity() throws -> [Reproduction] {
        let optionArguments = try argument.optionArgument(for: OptionType.specify)
        if optionArguments.isEmpty {
            throw ServiceError.argumentIsMissing("Should write for componentType. e.g kuri -s View")
        }
        
        return self.reproductions.filter { reproduction in
            return optionArguments.contains { option in
                return reproduction.templateType == option
            }
        }
    }
    
    fileprivate func executeForTemplateSpecify() throws -> String {
        let templateSpecity = OptionType.templateSpecify
        
        guard let templateDirectoryName = try argument.optionArgument(for: templateSpecity).first else {
            throw ServiceError.argumentIsMissing("Not enough argument for kuri \(templateSpecity.shortCut)")
        }
        
        return templateDirectoryName
    }
    
}

extension Generator {
    
    fileprivate func generate(with prefix: String, for reproductions: [Reproduction], and templatesRoot: String) throws {
        print("Begin generate")
        
        defer {
            print("End generate")
        }
        
        var pathAndXcodeProject: [String: XcodeProject] = [:]
        
        try reproductions.forEach { reproduction in
            let templateType = reproduction.templateType
            
            let stringYamlReader = YamlReader<String>(yaml: yaml)
            let booleanYamlReader = YamlReader<Bool>(yaml: yaml)
            
            let basePath = stringYamlReader.value(for: .GenerateRootPath, templateType: templateType)
            let projectRootPath = stringYamlReader.value(for: .ProjectRootPath, templateType: templateType)
            let projectFileName = stringYamlReader.value(for: .ProjectFileName, templateType: templateType)
            let targetName = stringYamlReader.value(for: .Target, templateType: templateType)
            
            let projectFilePath = projectRootPath + projectFileName + "/"
            
            let shouldRemoveLayerNameFromDirectoryName = booleanYamlReader.value(for: .ShouldRemoveLayerNameFromDirectory, templateType: templateType)
            
            let targetPath = shouldRemoveLayerNameFromDirectoryName
                ? basePath
                : basePath + reproduction.getReplacedDirectoryArray(prefix: prefix, targetName: targetName).joined(separator: "/") + "/"
            
            let filePath = targetPath + reproduction.fileName.replaceVariables(prefix: prefix, targetName: targetName)
            
            let project: XcodeProject
            
            if let alreadyExistsProject = pathAndXcodeProject[projectFilePath] {
                project = alreadyExistsProject
            } else {
                let xcodeprojectFileUrl = URL(fileURLWithPath: projectFilePath + "project.pbxproj")
                project = try XcodeProject(for: xcodeprojectFileUrl)
                pathAndXcodeProject[projectFilePath] = project
            }
            
            let templatePath = templatesRoot + reproduction.relativePathFromTemplatesRoot
            
            guard let templateContent = try? String(contentsOf: URL(fileURLWithPath: templatePath)) else {
                print("can't find: \(templateType)")
                return
            }
            
            try self.fileManager.createDirectory(atPath: targetPath
                , withIntermediateDirectories: true
                , attributes: nil
            )
            
            self.fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
            
            project.appendFilePath(with: projectRootPath
                , filePath: filePath
                , targetName: targetName
            )
            
            let writeCotent = templateContent.replaceVariables(prefix: prefix, targetName: targetName)
            try writeCotent.write(to: URL(fileURLWithPath: filePath)
                , atomically: true
                , encoding: String.Encoding.utf8
            )
            
            print("created: \(filePath)")
        }
        
        try pathAndXcodeProject.values.forEach {
            try $0.write()
            
            print("write in project: \($0.projectName).xcodeproj")
        }
    }
}
