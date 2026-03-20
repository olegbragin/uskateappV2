//
//  SummaryEventView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 05.02.2026.
//

import SwiftUI

struct SummaryEventView: View {
    @Bindable var model: SummaryEventModel
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(model.labels, id: \.id) { label in
                Text(label.name)
                    .padding(2)
                    .onTapGesture {
                        print(label.id)
                    }
            }
            Spacer()
            SummaryNumberOfEventsView(
                model: .init(numberOfEvents: model.labels.count)
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
