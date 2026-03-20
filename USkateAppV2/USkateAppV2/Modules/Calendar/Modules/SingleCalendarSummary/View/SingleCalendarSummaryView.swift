//
//  SingleCalendarSummaryView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 05.02.2026.
//

import SwiftUI

struct SingleCalendarSummaryView: View {
    @Bindable var viewModel: SingleCalendarSummaryModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 8) {
            VStack {
                ForEach(viewModel.events) {
                    SummaryEventView(model: $0)
                }
            }
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
        .padding()
    }
}
