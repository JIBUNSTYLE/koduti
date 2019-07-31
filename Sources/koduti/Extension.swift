//
//  Extension.swift
//  SwiftShell
//
//  Created by 斉藤 祐輔 on 2019/07/29.
//

import Foundation

extension String {
    
    fileprivate struct DateComponent {
        let year: Int
        let month: Int
        let day: Int
        
        var date: String {
            return "\(year)/\(month)/\(day)"
        }
    }
    
    func replaceVariables(prefix: String, targetName: String)  -> String {
        let userName = NSFullUserName()
        
        let date: DateComponent = { _ -> DateComponent in
            let component = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day], from: Date())
            guard let year = component.year
                , let month = component.month
                , let day = component.day else
            {
                fatalError("Can't get system date")
            }
            return DateComponent(year: year, month: month, day: day)
        }(())
        
        return self
            .replacingOccurrences(of: "__PREFIX__"  , with: prefix)
            .replacingOccurrences(of: "__prefix__"  , with: prefix.lowercased())
            .replacingOccurrences(of: "__TARGET__"  , with: targetName)
            .replacingOccurrences(of: "__USERNAME__", with: userName)
            .replacingOccurrences(of: "__DATE__"    , with: date.date)
            .replacingOccurrences(of: "__YEAR__"    , with: "\(date.year)")
            .replacingOccurrences(of: "__MONTH__"   , with: "\(date.month)")
            .replacingOccurrences(of: "__DAY__"     , with: "\(date.day)")
    }
}
