//
//  AddEditEventView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 13.03.2026.
//

import SwiftUI

struct AddEditEventView: View {
    @Bindable var viewModel: AddEditEventViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Поле ввода имени
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Имя")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            TextField("Введите имя", text: $viewModel.eventName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal, 4)
                        }
                        
                        // Выбор цвета
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Выберите цвет")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            ColorPickerView(selectedColor: $viewModel.selectedColor)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .title) {
                    Text(viewModel.selectedDay ?? Date(), style: .date)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            if viewModel.save() {
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
