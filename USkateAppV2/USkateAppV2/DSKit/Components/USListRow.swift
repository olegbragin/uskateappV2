//
//  SwiftUIView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 30.10.2025.
//

import SwiftUI

struct USListRow<Content: View>: View {
    let content: Content

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(Color.blue)
    }
}

#Preview {
    USListRow {
        USLabel("Hello world!")
    }
}
