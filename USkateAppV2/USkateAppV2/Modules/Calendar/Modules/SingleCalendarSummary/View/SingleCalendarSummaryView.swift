//
//  SingleCalendarSummaryView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 05.02.2026.
//

import SwiftUI

struct SingleCalendarSummaryView: View {
    @Bindable var viewModel: SingleCalendarSummaryModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("\(viewModel.year)")
                .font(.title)
                .foregroundStyle(.black)
            VStack {
                ForEach(viewModel.events) {
                    SummaryEventView(model: $0)
                }
            }
            .padding([.leading, .trailing, .bottom])
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
        .padding([.leading, .trailing])
    }
}

#Preview {
    SingleCalendarSummaryView(viewModel: SingleCalendarSummaryModel(
        year: 2026,
        events: [
            .init(label: "Doctor", color: "eventColorOption1", date: Date(), numberOfEvents: 4),
            .init(label: "Training", color: "eventColorOption2", date: Date(), numberOfEvents: 9),
            .init(label: "Birthdays", color: "eventColorOption3", date: Date(), numberOfEvents: 1),
            .init(label: "Goods", color: "eventColorOption4", date: Date(), numberOfEvents: 15),
            .init(label: "Tracks", color: "eventColorOption5", date: Date(), numberOfEvents: 1)
    ]))
}
