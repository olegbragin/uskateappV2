//
//  ContentView.swift
//  USkateAppV2Watch Watch App
//
//  Created by Oleg Bragin on 16.11.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: DispatchViewModel
    
    init(viewModel: DispatchViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hellow")
        }
        .padding()
        .alert(item: $viewModel.auth) { message in
             Alert(title: Text(message.text),
                   dismissButton: .default(Text("Dismiss")))
        }
    }
}

#Preview {
    ContentView()
}
