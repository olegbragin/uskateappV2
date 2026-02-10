//
//  SingleCalendarView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 04.02.2026.
//

import SwiftUI

struct SingleCalendarView: View {
    @StateObject private var model: SingleCalendarModel
    
    init(model: SingleCalendarModel = .init()) {
        _model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            USCalendarYearView(model:
                    .init(
                        year: model.year,
                        numberOfColumns: model.numberOfColumns
                    )
            )
        }
        .navigationTitle(model.label)
        .padding(6)
    }
}

#Preview {
    SingleCalendarView(
        model: .init(label: "SuperCal1", numberOfColumns: 1)
    )
}
