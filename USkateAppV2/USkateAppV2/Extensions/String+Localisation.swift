//
//  Untitled.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 17.11.2025.
//
import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func localized(_ args: CVarArg...) -> String {
        let localizedString = NSLocalizedString(self, comment: "")
        return String(format: localizedString, arguments: args)
    }
}
