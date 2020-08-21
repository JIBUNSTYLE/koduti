//
//  RouterTemplate.swift
//  SwiftShell
//
//  Created by 斉藤 祐輔 on 2019/07/29.
//

import Foundation

struct RouterTemplate: SourceCodeTemplate {
    
    let fileName = "__PREFIX__Router"
    let fileType = "swift"
    
    func parentDirectory() -> String {
        return "Service/Presentation/Routers"
    }
    
    func interface() -> String {
        return [
            "import UIKit"
            , ""
            , ""
            , "protocol __PREFIX__Wireframe: Wireframe where ViewController : __PREFIX__UserInterface { }"
        ].joined(separator: "\n")
    }
    
    func implementation() -> String {
        return [
            "struct __PREFIX__Router {"
            , "    typealias ViewController = __PREFIX__ViewController"
            , "    "
            , "    weak var vc: ViewController?"
            , "    "
            , "    init(vc: ViewController) {"
            , "        self.vc = vc"
            , "    }"
            , "    "
            , "    // MARK: - factory"
            , "    static func instantiate() -> ViewController {"
            , "        guard let vc = R.storyboard.__prefix__.instantiateInitialViewController() else {"
            , "            fatalError()"
            , "        }"
            , "        "
            , "        let interactor = __PREFIX__Interactor()"
            , "        let router = __PREFIX__Router(vc: vc)"
            , "        let presenter = __PREFIX__Presenter(vc: vc, interactor: interactor, router: router)"
            , "        vc.set(presenter: presenter)    // ViewにPresenterを設定"
            , "        "
            , "        return vc"
            , "    }"
            , "}"
            , ""
            , "// MARK: - __PREFIX__Wireframe プロトコルの実装"
            , "extension __PREFIX__Router : __PREFIX__Wireframe { }"
        ].joined(separator: "\n")
    }
}
