//
//  USCalendarWeekHeaderView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 28.01.2026.
//

import SwiftUI

struct USCalendarWeekHeaderView: View {
    let model = USCalendarWeekHeaderModel()
    
    var body: some View {
        HStack {
            ForEach(model.weekHeader) {
                USCalendarDayView(
                    model: .init(
                        text: $0.text,
                        columnCount: $0.columnCount
                    )
                )
            }
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    USCalendarWeekHeaderView()
}
