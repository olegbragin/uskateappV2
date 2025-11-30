//
//  DispatchView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 16.11.2025.
//
import SwiftUI

struct DispatchView: View {
    
    @StateObject private var viewModel: DispatchViewModel
    
    init(viewModel: DispatchViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            switch viewModel.desitnation {
            case .loading:
                VStack {
                    ProgressView {
                        Text("Loading")
                    }
                }
            case .content(let name):
                ContentView(
                    model: ContentModel(
                        data: name
                    )
                )
            default:
                VStack(spacing: 8) {
                    Image(.logo)
                    Text("Not authorized")
                }
            }
        }
        .task {
            await viewModel.fetchUserData()
        }
    }
}
