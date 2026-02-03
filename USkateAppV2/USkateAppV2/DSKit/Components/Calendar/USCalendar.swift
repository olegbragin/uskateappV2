//
//  SwiftUIView.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 11.01.2026.
//

import SwiftUI
import Combine

struct ScrollPositionPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

final class USCalendarViewModel: ObservableObject {
    @Published var columnCount: Int = 1
    @Published var scrollPosition: CGFloat = 0
        
    private let baseSensitivity: CGFloat = 0.12
    private let minSensitivity: CGFloat = 0.08

    private var smoothMagnification: CGFloat = 1.0  // Для сглаживания
    private var accumulatedDelta: CGFloat = 0.0  // Накопленная дельта
    private var lastMagnification: CGFloat = 1.0
    private var lastColumnCount: Int = 1

    // Для тактильной отдачи (опционально)
    private let hapticFeedback = UINotificationFeedbackGenerator()

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


struct USCalendarView: View {
    @StateObject private var model = USCalendarViewModel()
    
    // Временный масштаб во время жеста (сбрасывается после)
    @GestureState private var tempMagnification: CGFloat = 1.0
    @State private var gestureStartTime: Date?
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                USCalendarYearView(
                    model: .init(
                        numberOfColumnsToShow: model.columnCount
                    )
                )
                .id(model.columnCount)
            }
            .scrollTargetLayout()  // iOS 17+: сохраняет позицию при перестроении
            .onChange(of: model.columnCount) {
                // Дополнительно: плавная прокрутка к сохранённой позиции
                DispatchQueue.main.async {
                    proxy.scrollTo(10, anchor: .center)  // Пример: к элементу 10
                }
            }
            // Привязываем pinch-жест
            .highPriorityGesture(
                MagnifyGesture()
                    .updating($tempMagnification) { value, state, _ in
                        state = value.magnification
                        if gestureStartTime == nil {
                            gestureStartTime = Date()
                        }
                    }
                    .onEnded { value in
                        let duration = Date().timeIntervalSince(gestureStartTime ?? Date())
                        model.handleMagnify(
                            magnification: value.magnification,
                            velocity: value.velocity,
                            gestureDuration: duration
                        )
                        gestureStartTime = nil
                    }
            )
            .animation(.easeOut(duration: 0.3), value: model.columnCount)
            .onAppear {
                model.reset()
            }
        }
    }
}


#Preview {
    USCalendarView()
}
