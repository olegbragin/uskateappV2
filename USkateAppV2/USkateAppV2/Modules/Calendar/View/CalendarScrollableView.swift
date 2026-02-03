//
//  CalendarView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 10.01.2026.
//

import SwiftUI

struct CalendarScrollableView: View {
    // @Binding var selectedYearMonth: Date
    // @State private var selectedYearMonth = Date()

    var body: some View {
        USCalendarView()
    }
}

#Preview {
    @Previewable @State var selectedYearMonth = Date.now
    CalendarScrollableView()
}
