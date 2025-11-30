//
//  USLabel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 27.10.2025.
//

import SwiftUI

struct USLabel: View {
    let content: any StringProtocol
    
    init<S>(_ content: S) where S : StringProtocol {
        self.content = content
    }
    
    var body: some View {
        Text(content)
    }
}

#Preview {
    USLabel("Hello world!")
}
