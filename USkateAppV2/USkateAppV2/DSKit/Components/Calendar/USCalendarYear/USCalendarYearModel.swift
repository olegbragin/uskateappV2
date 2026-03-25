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
    private let baseSensitivity: CGFloat = 0.12
    private let minSensitivity: CGFloat = 0.08
    private let numberOfCurrentMonth: Int

    private var smoothMagnification: CGFloat = 1.0  // Для сглаживания
    private var accumulatedDelta: CGFloat = 0.0  // Накопленная дельта
    private var lastMagnification: CGFloat = 1.0
    private var lastNumberOfColumns: Int = 1

    // Для тактильной отдачи (опционально)
    private let hapticFeedback = UINotificationFeedbackGenerator()
    
    var numberOfColumns: Int = 1
    var scrollPosition: CGFloat = 0
    
    var selectedDays: Set<Date> = []
    var selectionMode: USCalendarSelectionMode = .single
    var isLongPressEnabled: Bool = false
    
    var indexOfCurrentMonth: Int? {
        return months.firstIndex { $0.number == numberOfCurrentMonth }
    }

    var months: [USCalendarMonthModel] = []
    
    init(months: [USCalendarMonthDataSource], numberOfCurrentMonth: Int, numberOfColumns: Int = 1) {
        self.numberOfColumns = numberOfColumns
        self.numberOfCurrentMonth = numberOfCurrentMonth
        self.months = months.map {
            .init(dto: $0)
        }
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
        
        var newCount = lastNumberOfColumns
        
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
        if newCount != lastNumberOfColumns {
            numberOfColumns = newCount
            lastNumberOfColumns = newCount
            // Дополнительный визуальный отклик (можно анимировать)
            hapticFeedback.notificationOccurred(.success)
        }
    }

    func reset() {
        numberOfColumns = 2
        lastNumberOfColumns = 2
        lastMagnification = 1.0
        accumulatedDelta = 0.0
    }
}
