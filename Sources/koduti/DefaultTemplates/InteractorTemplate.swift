//
//  InteractorTemplate.swift
//  SwiftShell
//
//  Created by 斉藤 祐輔 on 2019/07/29.
//

import Foundation

struct InteractorTemplate: SourceCodeTemplate {
    
    let fileType = "swift"
    let templateType = "Interactor"
    
    func parentDirectory() -> String {
        return "Service/Application/Usecases"
    }
    
    func interface() -> String {
        return [
            "import Foundation"
            , ""
            , ""
            , "protocol __PREFIX__Usecase : Usecase { }"
        ].joined(separator: "\n")
    }
    
    func implementation() -> String {
        return [
            "struct __PREFIX__Interactor: __PREFIX__Usecase { }"
        ].joined(separator: "\n")
    }
}
