//
//  SummaryEventView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 05.02.2026.
//

import SwiftUI

struct SummaryEventView: View {
    let model: SummaryEventModel
    
    init(model: SummaryEventModel) {
        self.model = model
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Text(model.label)
            Spacer()
            SummaryNumberOfEventsView(
                model: .init(numberOfEvents: model.numberOfEvents)
            )
        }
        .padding(
            .init(top: 4, leading: 24, bottom: 4, trailing: 24)
        )
        .frame(maxWidth: .infinity)
        .foregroundStyle(Color.white)
        .background(Color(model.color))
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
    }
}

#Preview {
    SummaryEventView(
        model: .init(
            label: "Doctor",
            color: "red",
            date: Date(),
            numberOfEvents: 4
        )
    )
}
