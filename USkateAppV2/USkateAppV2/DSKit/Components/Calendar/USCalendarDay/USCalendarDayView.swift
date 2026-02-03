//
//  USCalendarDayView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 25.01.2026.
//

import SwiftUI

struct USCalendarDayView: View {
    let model: USCalendarDayModel
    
    init(model: USCalendarDayModel) {
        self.model = model
    }
    
    private var textColor: Color {
        switch (model.isToday, model.isInCurrentMonth) {
        case (true, true), (true, false):
            return .white
        case (false, true):
            return Color("AccentColor")
        case (false, false):
            return Color("colorForeground")
        }
    }
    
    var body: some View {
        Text(model.text)
            .font(.caption.pointSize(8))
            .foregroundColor(Color(textColor))
            .background(.clear)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    USCalendarDayView(
        model: .init(
            text: "1"
        )
    )
}
