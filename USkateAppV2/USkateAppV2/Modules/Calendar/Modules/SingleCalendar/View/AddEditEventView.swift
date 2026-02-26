//
//  AddEditEventView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 24.02.2026.
//

import SwiftUI

struct AddEditEventView: View {
    @Binding var isPresented: Bool
    @Binding var event: EventDataSource
    @State var selectedColor: ColorOption = .option1
    @State var name = ""
    var date: Date?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            // Верхняя панель с кнопками
            HStack {
                Button("Отмена") {
                    isPresented = false
                }
                .foregroundColor(.red)
                
                Spacer()
                
                Text("Add Event")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding([.top, .bottom])
                
                Spacer()
                
                Button("Сохранить") {
                    saveProfile()
                    isPresented = false
                }
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            Divider()
            
            // Форма внутри ScrollView для лучшей прокрутки
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(date?.formatted() ?? "")
                    
                    // Поле ввода имени
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Имя")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        TextField("Введите имя", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 4)
                    }
                    
                    // Выбор цвета
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Выберите цвет")
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        ColorPickerView(selectedColor: $selectedColor)
                    }
                }
                .padding()
            }
        }
        .presentationDetents([.medium, .large]) // два уровня высоты: средний и большой
        .presentationDragIndicator(.visible) // показывает индикатор перетаскивания
    }
    
    private func saveProfile() {
        // Здесь логика сохранения данных
        if let date = date {
            event = EventDataSource(name: name, date: date, color: selectedColor.colorName)
        }
    }
}

#Preview {
    AddEditEventView(
        isPresented: .constant(true),
        event: .constant(.init(name: "aergaer", date: Date(), color: "")),
        date: Date()
    )
}
