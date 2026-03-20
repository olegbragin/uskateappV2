//
//  RootView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 07.02.2026.
//

import SwiftUI

struct RootView: View {
    @State var selector = RootSelectionCoordinator()
    
    var body: some View {
        NavigationSplitView {
            RootSidebarView(selector: $selector)
        } content: {
            RootContentView(selector: $selector)
        } detail: {
            RootDetailView(selector: $selector)
                .background(.colorBackgroundMain)
        }
        .padding(0)
    }
}
