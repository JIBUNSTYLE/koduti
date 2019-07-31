//
//  PresenterTemplate.swift
//  SwiftShell
//
//  Created by 斉藤 祐輔 on 2019/07/29.
//

import Foundation

struct PresenterTemplate: SourceCodeTemplate {
    
    let fileType = "swift"
    let templateType = "Presenter"
    
    func parentDirectory() -> String {
        return "Service/Presentation/Presenters"
    }
    
    func interface() -> String {
        return [
            "import Foundation"
            , "// UIKit禁止"
            , ""
            , ""
            , "protocol __PREFIX__Presentation: Presentation where ViewController: __PREFIX__UserInterface, Interactor: __PREFIX__Usecase, Router: __PREFIX__Wireframe { "
            , "    "
            , "    // MARK: - Lifecycle Events"
            , "    "
            , "    // MARK: - User Actions"
            , "    "
            , "}"
            ].joined(separator: "\n")
    }
    
    func implementation() -> String {
        return [
            "class __PREFIX__Presenter<T: __PREFIX__UserInterface, U: __PREFIX__Usecase, V: __PREFIX__Wireframe>: __PREFIX__Presentation {"
            , "    typealias ViewController = T"
            , "    typealias Interactor = U"
            , "    typealias Router = V"
            , "    "
            , "    let vc: ViewController"
            , "    let interactor: Interactor"
            , "    let router: Router"
            , "    "
            , "    required init(vc: ViewController, interactor: Interactor, router: Router) {"
            , "        self.vc = vc"
            , "        self.interactor = interactor"
            , "        self.router = router"
            , "    }"
            , "    "
            , "    // MARK: - Lifecycle Events"
            , "    "
            , "    // MARK: - User Actions"
            , "    "
            , "}"
        ].joined(separator: "\n")
    }
}
