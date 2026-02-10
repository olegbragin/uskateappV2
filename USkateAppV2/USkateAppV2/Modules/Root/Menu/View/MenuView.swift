//
//  Untitled.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 07.02.2026.
//

import SwiftUI

struct MenuView: View {
    @Bindable var model: MenuViewModel
    @Binding var columnVisibility: NavigationSplitViewVisibility
    
    var body: some View {
        List(selection: $model.selection) {
            Text("Calendars")
                .tag("calendars")
        }
        .listStyle(.sidebar)
        .navigationTitle("Меню")
        .onChange(of: model.selection) { _, newSelection in
            if let newSelection {
                columnVisibility = .detailOnly
            }
        }
    }
}
