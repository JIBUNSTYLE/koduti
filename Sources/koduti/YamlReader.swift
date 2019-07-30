//
//  YamlReader.swift
//  SwiftShell
//
//  Created by 斉藤 祐輔 on 2019/07/29.
//

import Foundation
import Yaml

public protocol YamlReadableType {
    static func read(by key: String, from yaml: Yaml) -> Self?
}

extension String: YamlReadableType {
    public static func read(by key: String, from yaml: Yaml) -> String? {
        return yaml[.string(key)].string
    }
}
extension Bool: YamlReadableType {
    public static func read(by key: String, from yaml: Yaml) -> Bool? {
        return yaml[.string(key)].bool
    }
}

public struct YamlReader<T: YamlReadableType> {
    
    public let yaml: Yaml
    
    public init(yaml: Yaml) {
        self.yaml = yaml
    }
    
    private func readYaml(by key: String, from yaml: Yaml) -> Yaml {
        return yaml[.string(key)]
    }
    
    private func read(by key: String, from yaml: Yaml) -> T? {
        return T.read(by: key, from: yaml)
    }
    
    private func readFromRoot(by key: ConfigProperties) -> T? {
        guard let value = read(by: key.rawValue, from: yaml) else {
            fatalError("Can't find for \(key.rawValue)")
        }
        return value
    }
    
    private func readYamlFromComponent(by key: ConfigProperties, and templateType: String, from yaml: Yaml) -> T? {
        let yamlForCompoennt = yaml[.string(templateType)]
        return T.read(by: key.rawValue, from: yamlForCompoennt)
    }
    
    private func readYamlForComponent(templateType: String, from yaml: Yaml) -> Yaml {
        if readYaml(by: templateType, from: yaml) == .null {
            fatalError("Can't find component \(templateType)")
        }
        return readYaml(by: templateType, from: yaml)
    }
    
    private func readYamlForComponent(reproduction: Reproduction, from yaml: Yaml) -> Yaml {
        var yamlForComponent: Yaml = yaml
        reproduction.directoriesArray.forEach { directory in
            yamlForComponent = yamlForComponent[.string(directory)]
            if yamlForComponent == .null {
                fatalError("Can't find \(directory) from \(reproduction.directoriesArray)")
            }
        }
        return yamlForComponent
    }
    
    /* read from yaml for key. If nessecary componentType and genearteComponent
     - parameter key: key is already define.
     - parameter componentType: e.g Entity, View, Presenter..., component type for generate.
     - parameter generateComponent: generateComponent used search `componentType` argument value.
     
     - returns: searched value for key
     */
    
    private func read(by key: ConfigProperties, and templateType: String? = nil, with reproduction: Reproduction? = nil) -> T? {
        // only top level
        guard let _templateType = templateType else {
            return readFromRoot(by: key)
        }
        
        // from top level search for key
        guard let _reproduction = reproduction else {
            return readYamlFromComponent(by: key, and: _templateType, from: yaml) ?? readFromRoot(by: key)
        }
        
        // recursive yaml component
        let yamlForContent = readYamlForComponent(reproduction: _reproduction, from: yaml)
        
        return readYamlFromComponent(by: key, and: _templateType, from: yamlForContent)
            ?? readYamlFromComponent(by: key, and: _templateType, from: yaml)
            ?? readFromRoot(by: key)
    }
    
    func value(for key: ConfigProperties, templateType: String? = nil, reproduction: Reproduction? = nil) -> T {
        guard let value = read(by: key, and: templateType, with: reproduction) else {
            fatalError("should write \(key.rawValue) in koduti.yml")
        }
        return value
    }
}

