//
//  AuthorizationView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 30.10.2025.
//

import SwiftUI

struct AuthorizationView: View {
    @StateObject private var viewModel: AuthorizationViewModel
    
    init(
        viewModel: AuthorizationViewModel = .init(loader: AuthorizationLoader(), connectivityProvider: WatchConnectivityProvider())
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
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
                            Button(action: {
                                Task {
                                    await viewModel.authorize()
                                }
                            }) {
                                Text("Sign In")
                                    .foregroundStyle(.accent)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            Button(action: {
                                viewModel.notify()
                            }) {
                                Text("Notify")
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
                    HStack(spacing: Spacing.ds16.rawValue) {
                        NavigationLink(destination: SignupView()) {
                            Text("Sign Up")
                        }
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot password?")
                        }
                    }
                    .padding()
                    if viewModel.isLoading {
                        ProgressView {
                            Text("Loading")
                        }
                    }
                }
            }
            .navigationDestination(for: AuthorizationViewModel.Route.self) { route in
                switch route {
                case .content(let data):
                    ContentView()
                        .navigationBarBackButtonHidden(true)
                default:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    AuthorizationView()
}
