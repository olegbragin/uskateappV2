//
//  ContentView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 22.10.2025.
//

import SwiftUI

struct ContentView: View {    
    var body: some View {
        CalendarsView(currentPage: .constant(0))
            .padding(0)
    }
}

#Preview {
    ContentView()
}
