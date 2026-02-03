//
//  USCalendarMonthProvider.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 01.02.2026.
//

import Foundation

struct USCalendarMonthProvider {
    let month: Int
    let year: Int
    
    let calendar: Calendar
    var weeks = [USCalendarWeekDataSource]()
    
    init(calendar: Calendar = .current, month: Int, year: Int) {
        self.calendar = calendar
        self.month = month
        self.year = year
        
        self.weeks =
            getCalendarWeeks(
                ofMonth: month,
                ofYear: year
            )
    }
    
    func shortLocalizedMonthName(locale: Locale = .current) -> String {
        // Проверка диапазона: месяц должен быть от 1 до 12
        guard (1...12).contains(month) else {
            return "—" // или можно бросить ошибку, если нужно
        }
        
        // Создаём дату для первого дня заданного месяца (год произвольный)
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        
        guard let date = Calendar.current.date(from: components) else {
            return "—"
        }
        
        // Настраиваем форматер для сокращённого названия месяца
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "MMM" // MMM → сокращённое название (Янв, Feb и т. п.)
        
        return formatter.string(from: date)
    }

    private func getCalendarWeeks(
        ofMonth: Int,
        ofYear: Int
    ) -> [USCalendarWeekDataSource] {
        let todayDate = Date()
        
        // 1. Первый день заданного месяца
        var components = DateComponents(year: ofYear, month: ofMonth, day: 1)
        guard let startOfMonth = calendar.date(from: components) else { return [] }
        
        // 2. Начало первой полной недели (может быть в предыдущем месяце)
        let startOfFirstWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startOfMonth))!
        
        // 3. Конец последней полной недели (может быть в следующем месяце)
        let endOfMonth = calendar.range(of: .day, in: .month, for: startOfMonth)!.count
        components.day = endOfMonth
        guard let lastDayOfMonth = calendar.date(from: components),
              let endOfLastWeek = date(byEndingOf: .weekOfYear, for: lastDayOfMonth)
        else { return [] }
        
        
        // 4. Генерируем все даты от startOfFirstWeek до endOfLastWeek
        var dates: [Date] = []
        var currentDate = startOfFirstWeek
        
        while currentDate <= endOfLastWeek {
            dates.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        // 5. Группируем по неделям
        var weeks: [USCalendarWeekDataSource] = []
        var currentWeek: [USCalendarDayDataSource] = []
        
        for date in dates {
            let weekday = calendar.component(.weekday, from: date)
            let isFirstDayOfWeek = weekday == calendar.firstWeekday
            
            
            if isFirstDayOfWeek && !currentWeek.isEmpty {
                weeks.append(
                    USCalendarWeekDataSource(days: currentWeek)
                )
                currentWeek = []
            }
            
            // Преобразуем дату в Day
            let dayNumber = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)
            let year = calendar.component(.year, from: date)
            let isInMonth = (month == ofMonth) && (year == ofYear)
            
            currentWeek.append(
                USCalendarDayDataSource(
                    date: date,
                    number: dayNumber,
                    isInCurrentMonth: isInMonth,
                    isToday: calendar.isDate(date, inSameDayAs: todayDate) && isInMonth
                )
            )
        }
        
        if !currentWeek.isEmpty {
            weeks.append(
                USCalendarWeekDataSource(days: currentWeek)
            )
        }
        
        // 6. Если недель меньше 6 — дополняем следующими неделями
        while weeks.count < 6 {
            // Берём последний день последней недели
            guard let lastDate = weeks.last?.days.last?.date else { break }
            
            // Генерируем следующую неделю (7 дней после lastDate)
            var nextWeekDates: [Date] = []
            var nextDate = calendar.date(byAdding: .day, value: 1, to: lastDate)!
            for _ in 0..<7 {
                nextWeekDates.append(nextDate)
                guard let futureDate = calendar.date(byAdding: .day, value: 1, to: nextDate) else { break }
                nextDate = futureDate
            }
            
            // Преобразуем даты в Day
            let nextWeekDays = nextWeekDates.map { date in
                let dayNumber = calendar.component(.day, from: date)
                let month = calendar.component(.month, from: date)
                let year = calendar.component(.year, from: date)
                let isInMonth = (month == ofMonth) && (year == ofYear)
                return USCalendarDayDataSource(
                    date: date,
                    number: dayNumber,
                    isInCurrentMonth: isInMonth,
                    isToday: calendar.isDate(date, inSameDayAs: todayDate) && isInMonth
                )
            }
            
            weeks.append(
                USCalendarWeekDataSource(days: nextWeekDays)
            )
        }
        
        return weeks
    }
    
    private func date(byEndingOf component: Calendar.Component, for date: Date) -> Date? {
        var comps = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        switch component {
        case .weekOfYear:
            // Находим начало недели, затем добавляем 6 дней и 23:59:59
            if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) {
                var endComps = DateComponents()
                endComps.day = 6
                endComps.hour = 23
                endComps.minute = 59
                endComps.second = 59
                return calendar.date(byAdding: endComps, to: startOfWeek)
            }
            return nil
            
        case .month:
            comps.day = calendar.range(of: .day, in: .month, for: date)?.count
            comps.hour = 23
            comps.minute = 59
            comps.second = 59
            return calendar.date(from: comps)
            
        case .day:
            comps.hour = 23
            comps.minute = 59
            comps.second = 59
            return calendar.date(from: comps)
            
        default:
            return nil
        }
    }
}
