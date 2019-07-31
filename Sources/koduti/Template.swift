//
//  Template.swift
//  SwiftShell
//
//  Created by 斉藤 祐輔 on 2019/07/29.
//

import Foundation

protocol Template {
    var fileType: String { get }
    func parentDirectory() -> String
    func body() -> String
}

protocol SourceCodeTemplate : Template {
    var templateType: String { get }
    func parentDirectory() -> String
    func interface() -> String
    func implementation() -> String
    func body() -> String
}

extension SourceCodeTemplate {
    
    func body() -> String {
        return self.comment()
            + "\n"
            + self.interface()
            + "\n\n\n"
            + self.implementation()
    }
    
    func comment() -> String {
        return [
            "//"
            , "//  __PREFIX__\(templateType).swift"
            , "//  __TARGET__"
            , "//"
            , "//  Created by __USERNAME__ on __DATE__."
            , "//"
            , ""
        ].joined(separator: "\n")
    }
}
