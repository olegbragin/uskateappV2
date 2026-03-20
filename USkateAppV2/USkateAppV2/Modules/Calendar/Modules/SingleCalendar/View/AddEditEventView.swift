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
        VStack {
            // Верхняя панель с кнопками
            HStack {
                Button("Закрыть") {
                    viewModel.cancel()
                }
                .foregroundColor(.red)
                
                Spacer()
                
                Text("Add Event")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding([.top, .bottom])
                
                Spacer()
                
                Button("Сохранить") {
                    Task {
                        if viewModel.save() {
                            dismiss()
                        }
                    }
                }
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            Divider()
            
            // Форма внутри ScrollView для лучшей прокрутки
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(viewModel.selectedDay?.formatted() ?? "")
                    
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
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}
