//
//  USEditButton.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 26.03.2026.
//

import SwiftUI

struct USEditButton: View {
    @Environment(\.editMode) private var editMode
    @State private var isEditing: Bool = false
    
    private let action: () -> Void
    
    init(action: @escaping () -> Void = {}) {
        self.action = action
    }
    
    var body: some View {
        Button {
            isEditing.toggle()
            editMode?.wrappedValue = isEditing ? .active : .inactive
            action()
        } label: {
            if isEditing {
                Image(systemName: "checkmark")
            } else {
                Text("Edit")
            }
        }
        .padding([.trailing])
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.25), value: isEditing)
        .onChange(of: editMode?.wrappedValue) { _, newValue in
            isEditing = newValue == .active
        }
    }
}

#Preview {
    USEditButton()
}
