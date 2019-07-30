//
//  ViperProtocols.swift
//  SwiftShell
//
//  Created by 斉藤 祐輔 on 2019/07/30.
//

import Foundation

struct ViperProtocolsTemplate : Template {
    
    func parentDirectory() -> String {
        return "System"
    }
    
    func body() -> String {
        return [
            "import Foundation"
            , ""
            , "// MARK: - View"
            , "protocol UserInterface : AnyObject {"
            , "    associatedtype Presenter : Presentation"
            , "    var presenter: Presenter? { get set }"
            , "    "
            , "    func set(presenter: Presenter)"
            , "}"
            , ""
            , "extension UserInterface {"
            , "    func set(presenter: Presenter) {"
            , "        self.presenter = presenter"
            , "    }"
            , "}"
            , ""
            , "// MARK: - Interactor"
            , "protocol Usecase { }"
            , ""
            , "// MARK: - Presenter"
            , "protocol Presentation : AnyObject {"
            , "    associatedtype ViewController : UserInterface"
            , "    associatedtype Interactor : Usecase"
            , "    associatedtype Router : Wireframe"
            , "    "
            , "    var vc: ViewController { get }"
            , "    var interactor: Interactor { get }"
            , "    var router: Router { get }"
            , "    "
            , "    init(vc: ViewController, interactor: Interactor, router: Router)"
            , "}"
            , ""
            , "// MARK: - Entity"
            , "protocol Entity : Codable { }"
            , ""
            , ""
            , "// MARK: - Router"
            , "protocol Wireframe {"
            , "    associatedtype ViewController : UserInterface"
            , "    var vc: ViewController { get }"
            , "    static func factory() -> ViewController"
            , "}"
            , ""
            , "// MARK: - Repository"
            , "protocol Repository { }"
        ].joined(separator: "\n")
    }
}
