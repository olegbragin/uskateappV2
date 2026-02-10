//
//  SingleCalendarSummaryView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 05.02.2026.
//

import SwiftUI

struct SingleCalendarSummaryView: View {
    let model = SingleCalendarSummaryModel(
        label: "Super Cal1",
        year: Date(),
        events: [
            .init(label: "Doctor", color: "eventColorOption1", numberOfEvents: 4),
            .init(label: "Training", color: "eventColorOption2", numberOfEvents: 9),
            .init(label: "Birthdays", color: "eventColorOption3", numberOfEvents: 1),
            .init(label: "Goods", color: "eventColorOption4", numberOfEvents: 15),
            .init(label: "Tracks", color: "eventColorOption5", numberOfEvents: 1)
    ])
    
    var body: some View {
        VStack(spacing: 24) {
            VStack {
                Text(model.label)
                    .padding(4)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.white)
                    .background(Color.blue)
                Text(model.year, format: .dateTime.year())
                    .font(.footnote)
                    .foregroundStyle(.white)
            }
            VStack {
                ForEach(model.events) {
                    SummaryEventView(model: $0)
                }
            }
            .padding([.leading, .trailing, .bottom])
        }
        .background(Color.gray.opacity(0.6))
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
    }
}

#Preview {
    SingleCalendarSummaryView()
}
