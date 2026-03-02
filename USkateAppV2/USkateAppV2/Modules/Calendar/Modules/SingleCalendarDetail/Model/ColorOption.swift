//
//  ColorOption.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 24.02.2026.
//

import SwiftUI

enum ColorOption: CaseIterable {
    case option1,
         option2,
         option3,
         option4,
         option5
    
    var color: Color {
        switch self {
        case .option1: return Color("eventColorOption1")
        case .option2: return Color("eventColorOption2")
        case .option3: return Color("eventColorOption3")
        case .option4: return Color("eventColorOption4")
        case .option5: return Color("eventColorOption5")
        }
    }
    
    var colorName: String {
        switch self {
        case .option1: return "eventColorOption1"
        case .option2: return "eventColorOption2"
        case .option3: return "eventColorOption3"
        case .option4: return "eventColorOption4"
        case .option5: return "eventColorOption5"
        }
    }
    
    var name: String {
        switch self {
        case .option1: return "Вариант 1"
        case .option2: return "Вариант 2"
        case .option3: return "Вариант 3"
        case .option4: return "Вариант 4"
        case .option5: return "Вариант 5"
        }
    }
}

