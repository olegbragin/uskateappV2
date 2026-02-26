//
//  USCalendarDayView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 25.01.2026.
//

import SwiftUI

struct USCalendarDayView: View {
    @Bindable var model: USCalendarDayModel
    
    var body: some View {
        ZStack {
            Rectangle()
            .fill(
                LinearGradient(
                    colors: model.events,
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .drawingGroup()
            .allowsHitTesting(false)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .aspectRatio(1, contentMode: .fit)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
            )
            .padding(2)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor, lineWidth: 0.5)
            )
            
            // Текст
            USLabel(model.text)
                .font(font)
                .foregroundColor(Color(textColor))
                .background(.clear)
                .shadow(radius: 2)
        }
        .id(model.events.count)
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
    
    private var font: Font {
        switch model.columnCount {
        case 3:
            return .caption.pointSize(8)
        default:
            return .caption
        }
    }
    
    private var backgroundColor: Color {
        guard model.isDayNumber else { return .clear }
        switch (model.isToday, model.isInCurrentMonth) {
        case (true, true), (true, false):
            return Color("colorBackground")
        case (false, true):
            return Color("colorBackground")
        case (false, false):
            return Color("colorBackgroundDisabled")
        }
    }
    
    private var borderColor: Color {
        switch (model.isToday, model.isInCurrentMonth) {
        case (true, true), (true, false):
            return .red
        default:
            return .clear
        }
    }
}

#Preview {
    USCalendarDayView(
        model: .init(
            text: "1",
            columnCount: 2,
            date: Date(),
            events: [
                .black,
                .green,
                .orange,
                .mint,
                .indigo
            ]
        )
    )
}
