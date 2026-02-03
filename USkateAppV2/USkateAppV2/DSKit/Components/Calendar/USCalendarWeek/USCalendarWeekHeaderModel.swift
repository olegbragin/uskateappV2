//
//  USCalendarWeekHeaderModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 28.01.2026.
//

import Foundation

struct USCalendarWeekHeaderModel {
    let calendar: Calendar
    var weekSymbols = [String]()
    
    var weekHeader: [USCalendarDayModel] {
        return weekSymbols.map {
            USCalendarDayModel(text: $0)
        }
    }
    
    init(calendar: Calendar = .autoupdatingCurrent) {
        self.calendar = calendar
        self.weekSymbols = getFirstLettersOfLocalizedWeekdays()
    }
    
    private func getFirstLettersOfLocalizedWeekdays() -> [String] {
        // Сдвиг: преобразуем firstWeekday (1–7) в индекс (0–6)
        let firstWeekDayshift = calendar.firstWeekday - 1
        
        // Перестраиваем массив: элементы с `firstWeekDayshift` до конца + элементы с начала до `firstWeekDayshift`
        let orderedNames = Array(
            calendar.weekdaySymbols[firstWeekDayshift...] +
            calendar.weekdaySymbols[..<firstWeekDayshift]
        )
        
        // Извлекаем первую букву каждого названия (заглавную)
        return orderedNames.map { name in
            guard
                !name.isEmpty,
                let firstScalar = name.unicodeScalars.first
            else { return "" }
            return String(firstScalar).uppercased()
        }
    }
}
