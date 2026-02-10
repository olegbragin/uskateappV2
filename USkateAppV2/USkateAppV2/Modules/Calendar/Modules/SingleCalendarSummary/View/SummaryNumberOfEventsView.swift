//
//  SummaryNumberOfEventsView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 05.02.2026.
//

import SwiftUI

struct SummaryNumberOfEventsView: View {
    let model: SummaryNumberOfEventsModel
    
    init(model: SummaryNumberOfEventsModel) {
        self.model = model
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white, lineWidth: 1)
                .aspectRatio(1, contentMode: .fit)  // Сохраняет пропорции
                .layoutPriority(-1)  // Чтобы круг не «перекрывал» текст
                .frame(width: 32, height: 32)
            Text(model.text)
                .padding(4)
        }
        .padding(2)  // Общий отступ от края
    }
}

#Preview {
    SummaryNumberOfEventsView(
        model: .init(numberOfEvents: 9)
    )
}
