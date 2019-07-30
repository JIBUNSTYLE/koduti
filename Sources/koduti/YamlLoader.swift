//
//  YamlFile.swift
//  SwiftShell
//
//  Created by 斉藤 祐輔 on 2019/07/29.
//

import Foundation
import SwiftShell
import Yaml

public struct YamlLoader {
    
    private static func find(file name: String) -> URL? {
        let path = run(bash: "ls | grep \(name)").stdout
        return URL(fileURLWithPath: path)
    }
    
    public static func loadYamlIfPossible() throws -> Yaml {
        let yaml: Yaml
        
        guard let yamlFile = find(file: CONFIG_FILE_NAME) else {
            throw ServiceError.yamlFileNotFound("Can't find Kuri.yml, please prepare this file.")
        }
        
        do {
            let yamlContent = try String(contentsOf: yamlFile)
            yaml = try Yaml.load(yamlContent)
            
        } catch {
            throw ServiceError.cannotReadYamlFile("Can't load yaml file.")
        }
        
        return yaml
    }
}
