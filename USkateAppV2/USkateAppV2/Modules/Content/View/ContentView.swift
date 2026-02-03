//
//  ContentView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 22.10.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    private let model: ContentModel
    
    init(model: ContentModel) {
        self.model = model
    }

//    var body: some View {
//        NavigationSplitView {
//            USList {
//                ForEach(items) { item in
//                    USListRow {
//                        let itemText = item.timestamp.formatted(Date.FormatStyle(date: .numeric, time: .standard))
//                        NavigationLink {
//                            USLabel(
//                                itemText
//                            )
//                        } label: {
//                            USLabel(itemText)
//                        }
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//#if os(macOS)
//            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
//#endif
//            .toolbar {
//#if os(iOS)
//                ToolbarItem(placement: .automatic) {
//                    EditButton()
//                }
//#endif
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
//    }
    var body: some View {
        NavigationSplitView {
            VStack(spacing: 8) {
                Image(.logo)
                Text(model.greeting)
            }
        } detail: {
            Text(model.greeting)
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView(
        model: ContentModel(
            data: "User1"
        )
    )
    .modelContainer(for: Item.self, inMemory: true)
}
