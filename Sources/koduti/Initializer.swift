//
//  Setup.swift
//  SwiftShell
//
//  Created by 斉藤 祐輔 on 2019/07/29.
//

import Foundation
import SwiftShell
import XcodeProject

public struct Initializer {
    let args: [String]
    let fileManager = Files
    
    public init(args: [String]) {
        self.args = args
    }
    
    public func execute() throws {
        
        guard let xcodeProjectFileName = run(bash: "ls | grep xcodeproj")
            .stdout
            .components(separatedBy: "\n")
            .first else
        {
            throw ServiceError.xcodeProjectFileNotFound("Please exec exists .xcodeproj directory.")
        }
        
        self.fileManager.createFile(atPath: "./\(CONFIG_FILE_NAME)", contents: nil, attributes: nil)
        
        guard let projectName = xcodeProjectFileName.components(separatedBy: ".").first else {
            throw ServiceError.xcodeProjectFileNameIsMissing("Wrong format for .xcodeproj. Please check exists .xcodeproj file.")
        }
        
        try createYamlFile(xcodeProjectFileName: xcodeProjectFileName, projectName: projectName)
        try createProtocols(xcodeProjectFileName: xcodeProjectFileName, projectName: projectName)
        try createTemplates()
        
        print("Successfully initializing!")
    }
    
    private func createYamlFile(xcodeProjectFileName: String, projectName: String) throws {

        let content = [
            "\(ConfigProperties.DefaultTemplateDirectoryPath.rawValue): ./\(TEMPLATES_DIRECTORY_NAME)/",
            "\(ConfigProperties.ProjectRootPath.rawValue): ./",
            "\(ConfigProperties.ProjectFileName.rawValue): \(xcodeProjectFileName)",
            "\(ConfigProperties.GenerateRootPath.rawValue): ./\(projectName)/",
            "\(ConfigProperties.Target.rawValue): \(projectName)",
            "\(ConfigProperties.ShouldRemoveLayerNameFromDirectory.rawValue): \(false)",
            "",
        ].joined(separator: "\n")
        
        try content.write(to: URL(fileURLWithPath: "./\(CONFIG_FILE_NAME)")
            , atomically: true
            , encoding: String.Encoding.utf8
        )
        
        print("created \(CONFIG_FILE_NAME).")
    }
    
    private func createProtocols(xcodeProjectFileName: String, projectName: String) throws {
        let outputPath = "./\(projectName)/"
        
        let _template = ViperProtocolsTemplate()
        
        let directoryPath = outputPath + _template.parentDirectory() + "/"
        try self.fileManager.createDirectory(atPath: directoryPath
            , withIntermediateDirectories: true
            , attributes: nil
        )
        
        let filePath = directoryPath + "ViperProtocols.\(_template.fileType)"
        self.fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
        
        let content = _template.body().replaceVariables(prefix: "", targetName: projectName)
        try content.write(to: URL(fileURLWithPath: filePath)
            , atomically: true
            , encoding: String.Encoding.utf8
        )
        
        let xcodeprojectFileUrl = URL(fileURLWithPath: "./\(xcodeProjectFileName)/" + "project.pbxproj")
        let project = try XcodeProject(for: xcodeprojectFileUrl)
        
        project.appendFilePath(with: "./"
            , filePath: filePath
            , targetName: projectName
        )
        try project.write()
        
        print("created the template for ViperProtocols.swift at \(filePath)")
    }
    
    private func createTemplates() throws {
        let outputPath = "./\(TEMPLATES_DIRECTORY_NAME)/"
        
        try DefaultTemplates.elements.forEach { template in
            let _template = template.template()
            
            let directoryPath = outputPath + _template.parentDirectory() + "/"
            try self.fileManager.createDirectory(atPath: directoryPath
                , withIntermediateDirectories: true
                , attributes: nil
            )
            
            let filePath = directoryPath + template.fileName + ".\(_template.fileType)"
            self.fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
            
            let content = _template.body()
            try content.write(to: URL(fileURLWithPath: filePath)
                , atomically: true
                , encoding: String.Encoding.utf8
            )
            
            print("created the template for \(template.name) at \(filePath)")
        }
    }
}
