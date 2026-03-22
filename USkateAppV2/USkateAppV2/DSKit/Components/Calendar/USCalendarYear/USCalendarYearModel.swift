//
//  USCalendarYearModel.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 01.02.2026.
//

import Combine
import SwiftUI

struct ScrollPositionPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

@Observable
final class USCalendarYearModel {
    
    var year: Int = 2026
    var columnCount: Int = 1
    var scrollPosition: CGFloat = 0
    var events: [EventDataSource] = []
    
    private let baseSensitivity: CGFloat = 0.12
    private let minSensitivity: CGFloat = 0.08

    private var smoothMagnification: CGFloat = 1.0  // Для сглаживания
    private var accumulatedDelta: CGFloat = 0.0  // Накопленная дельта
    private var lastMagnification: CGFloat = 1.0
    private var lastColumnCount: Int = 1

    // Для тактильной отдачи (опционально)
    private let hapticFeedback = UINotificationFeedbackGenerator()
    
    var indexOfCurrentMonth: Int? {
        let currentMonth = Calendar.current.component(.month, from: Date())
        return months.firstIndex { $0.number == currentMonth }
    }

    var months: [USCalendarMonthModel] {
        [
            .init(monthProvider: .init(month: 1, year: year, events: events), columnCount: columnCount),
            .init(monthProvider: .init(month: 2, year: year, events: events), columnCount: columnCount),
            .init(monthProvider: .init(month: 3, year: year, events: events), columnCount: columnCount),
            .init(monthProvider: .init(month: 4, year: year, events: events), columnCount: columnCount),
            .init(monthProvider: .init(month: 5, year: year, events: events), columnCount: columnCount),
            .init(monthProvider: .init(month: 6, year: year, events: events), columnCount: columnCount),
            .init(monthProvider: .init(month: 7, year: year, events: events), columnCount: columnCount),
            .init(monthProvider: .init(month: 8, year: year, events: events), columnCount: columnCount),
            .init(monthProvider: .init(month: 9, year: year, events: events), columnCount: columnCount),
            .init(monthProvider: .init(month: 10, year: year, events: events), columnCount: columnCount),
            .init(monthProvider: .init(month: 11, year: year, events: events), columnCount: columnCount),
            .init(monthProvider: .init(month: 12, year: year, events: events), columnCount: columnCount)
        ]
    }
    
    init(year: Int, numberOfColumns: Int, events: [EventDataSource] = []) {
        self.year = year
        self.columnCount = numberOfColumns
        self.events = events
    }
    
    /// Обрабатывает жест масштабирования
    /// - Parameters:
    ///   - magnification: Текущий коэффициент масштабирования
    ///   - velocity: Скорость изменения масштаба (CGFloat)
    func handleMagnify(
        magnification: CGFloat,
        velocity: CGFloat,
        gestureDuration: TimeInterval  // Передаётся из View (длительность жеста)
    ) {
        // 1. Сглаживание входного значения масштабирования
        let smoothingFactor: CGFloat = 0.3
        smoothMagnification = smoothMagnification * (1 - smoothingFactor) + magnification * smoothingFactor
        
        let effectiveMagnification = smoothMagnification
        
        
        // 2. Вычисляем дельту относительно предыдущего сглаженного значения
        let delta = effectiveMagnification - lastMagnification
        lastMagnification = effectiveMagnification
        
        
        // 3. Адаптивный порог в зависимости от скорости и длительности жеста
        let speedInfluence = min(abs(velocity) / 300.0, 0.8)  // Нормализация скорости
        let durationInfluence = min(gestureDuration / 0.3, 1.0)  // Чем дольше жест, тем ниже порог
        let dynamicThreshold = baseSensitivity * (1.0 - speedInfluence * 0.7 - durationInfluence * 0.3)
        let finalThreshold = max(minSensitivity, dynamicThreshold)  // Минимум — minSensitivity
        
        
        // 4. Накопление дельты с экспоненциальным затуханием и усилением текущего движения
        accumulatedDelta = accumulatedDelta * 0.65 + delta * 1.5
        
        
        // 5. Гистерезис: требуется превышение порога в 1.6 раза для срабатывания
        let triggerThreshold = finalThreshold * 1.6
        
        var newCount = lastColumnCount
        
        if accumulatedDelta > triggerThreshold {
            newCount -= 1
            // Частичный сброс накопленной дельты (оставляем 25% для плавного продолжения)
            accumulatedDelta *= 0.25
        } else if accumulatedDelta < -triggerThreshold {
            newCount += 1
            accumulatedDelta *= 0.25
        }
        
        // 6. Ограничение диапазона колонок
        newCount = max(1, min(newCount, 3))
        
        // 7. Обновление состояния только при изменении
        if newCount != lastColumnCount {
            columnCount = newCount
            lastColumnCount = newCount
            // Дополнительный визуальный отклик (можно анимировать)
            hapticFeedback.notificationOccurred(.success)
        }
    }

    func reset() {
        columnCount = 2
        lastColumnCount = 2
        lastMagnification = 1.0
        accumulatedDelta = 0.0
    }
}
