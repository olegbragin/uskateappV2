//
//  SingleDayView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import SwiftUI

struct SingleCalendarDetailView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var orientation: UIDeviceOrientation = .portrait
    
    var body: some View {
        ScrollView {
            if orientation == .portrait || orientation == .portraitUpsideDown {
                VStack(spacing: 16) {
                    USCalendarMonthView(model: .init(monthProvider: .init(month: 1, year: 2026), columnCount: 2))
                    SingleCalendarSummaryView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(16)
            } else {
                HStack(alignment: .center, spacing: 16) {
                    USCalendarMonthView(model: .init(monthProvider: .init(month: 1, year: 2026), columnCount: 2))
                    SingleCalendarSummaryView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(16)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            orientation = UIDevice.current.orientation
        }
        .id(orientation)
    }
}

#Preview {
    SingleCalendarDetailView()
}
