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
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Button("Back") {
                    print("back")
                }
                Text(viewModel.selectedDay ?? Date(), style: .date)
                Button("Save") {
                    Task {
                        if viewModel.save() {
                            dismiss()
                        }
                    }
                }
            }
            // Поле ввода имени
            VStack(alignment: .leading, spacing: 8) {
                Text("Имя")
                    .font(.headline)
                    .fontWeight(.medium)
                
                TextField("Введите имя", text: $viewModel.eventName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 4)
                    .ignoresSafeArea(.keyboard)
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
