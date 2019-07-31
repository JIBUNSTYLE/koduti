//
//  ViewControllerTemplate.swift
//  SwiftShell
//
//  Created by 斉藤 祐輔 on 2019/07/29.
//

import Foundation

struct ViewControllerTemplate: SourceCodeTemplate {
    
    let fileName = "__PREFIX__ViewController"
    let fileType = "swift"
    
    func parentDirectory() -> String {
        return "Service/Presentation/ViewControllers"
    }
    
    func interface() -> String {
        return [
            "import UIKit"
            , ""
            , ""
            , "protocol __PREFIX__UserInterface: UserInterface where Presenter : __PREFIX__Presentation { }"
        ].joined(separator: "\n")
    }
    
    func implementation() -> String {
        return [
            "class __PREFIX__ViewController: UIViewController {"
            , "    "
            , "    var presenter: Presenter?"
            , "    "
            , "    // MARK: - Lifecycle Events"
            , "    "
            , "    override func viewDidLoad() {"
            , "        super.viewDidLoad()"
            , "    }"
            , "    "
            , "    // MARK: - User Actions"
            , "    "
            , "}"
            , ""
            , "// MARK: - __PREFIX__UserInterface プロトコルの実装"
            , "extension __PREFIX__ViewController: __PREFIX__UserInterface {"
            , "    typealias Presenter = __PREFIX__Presenter<__PREFIX__ViewController, __PREFIX__Interactor, __PREFIX__Router>"
            , "    "
            , "    func set(presenter: Presenter) {"
            , "        self.presenter = presenter"
            , "    }"
            , "}"
        ].joined(separator: "\n")
    }
}
