//
//  USList.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 30.10.2025.
//

import SwiftUI

struct USList<Content: View>: View {
    let content: Content

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        List {
            content
        }
        .navigationTitle("My list")
        .listStyle(.automatic)
        .scrollContentBackground(.hidden)
        .background(Color.yellow)
    }
}

#Preview {
    let myitems = [
        Item(timestamp: Date())
    ]
    USList {
        ForEach(myitems) { item in
            USListRow {
                let itemText = item.timestamp.formatted(Date.FormatStyle(date: .numeric, time: .standard))
                NavigationLink {
                    USLabel(
                        itemText
                    )
                } label: {
                    USLabel(itemText)
                }
            }
        }
    }
}
