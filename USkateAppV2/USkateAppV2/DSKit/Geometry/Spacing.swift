//
//  File.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 09.11.2025.
//

import CoreGraphics

enum Spacing: RawRepresentable {
    typealias RawValue = CGFloat
    
    case ds48
    case ds30
    case ds16
    case ds8
    
    init?(rawValue: CGFloat) {
        switch rawValue {
        case 48.0:
            self = .ds48
        case 30.0:
            self = .ds30
        case 16.0:
            self = .ds16
        case 8.0:
            self = .ds8
        default:
            return nil
        }
    }
    
    var rawValue: CGFloat {
        switch self {
        case .ds48:
            return 48.0
        case .ds30:
            return 30.0
        case .ds16:
            return 16.0
        case .ds8:
            return 8.0
        }
    }
}
