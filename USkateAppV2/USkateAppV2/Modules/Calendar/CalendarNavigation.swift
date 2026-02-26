//
//  CalendarNavigation.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 23.02.2026.
//

import SwiftUI
import Combine

enum CalendarRoute: Equatable, Hashable {
    case details(id: Int64, month: Int)
}

final class CalendarNavigation: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to route: CalendarRoute) {
        switch route {
        case .details(let id, let month):
            path.append(CalendarRoute.details(id: id, month: month))
        }
    }
    
    func back() {
        path.removeLast()
    }
    
    func reset() {
        path = NavigationPath()
    }
}

