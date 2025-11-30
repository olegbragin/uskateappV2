//
//  AuthorizationView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 30.10.2025.
//

import SwiftUI

struct AuthorizationView: View {
    var body: some View {
        VStack(alignment: .center, spacing: Spacing.ds48.rawValue) {
            Image(.logo)
                .padding()
            VStack {
                Text("Slide in")
                    .font(.largeTitle)
                HStack {
                    VStack(alignment: .center, spacing: Spacing.ds16.rawValue) {
                        VStack {
                            TextField("Enter your email", text: .constant(""))
                            Divider()
                                .overlay(.blue)
                        }
                        VStack {
                            SecureField("Enter your password", text: .constant(""))
                            Divider()
                                .overlay(.blue)
                        }
                        Button(action: {}) {
                            Text("Sign In")
                                .foregroundStyle(.accent)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .padding()
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.blue, lineWidth: 0.5)
                )
                .padding()
            }
        }
    }
}

#Preview {
    AuthorizationView()
}
