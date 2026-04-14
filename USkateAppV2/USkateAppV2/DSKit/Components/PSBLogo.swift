//
//  PSBLogo.swift
//  USkateAppV2
//
//  Created by Oleg Bragin on 27.03.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Canvas { context, size in
            // Параметры холста (размеры подстроены под вертикальную ориентацию)
            let width = size.width  // ширина холста = высота логотипа
            let height = size.height  // высота холста = ширина логотипа
            let originX = CGFloat(0)  // отступ слева для графики
            let originY = CGFloat(0)  // отступ сверху для текста
            
            // Цвета логотипа ПСБ (замените на точные HEX-коды из гайдлайнов)
            let orangeColor = Color(red: 1.0, green: 0.5, blue: 0.0)  // оранжевый
            let blackColor = Color.black
            
            // 1. Отрисовка графического элемента (слева), повёрнутого на 90°
            drawRotatedGraphicElement(
                context, originX: originX,
                originY: originY,
                size: CGSize(width: width, height: height),
                color: orangeColor,
                contextColor: blackColor
            )
            
            // 2. Отрисовка букв «ПСБ» линиями (каждая буква — отдельный путь), повёрнутых на 90°
            // drawRotatedLetterP(context, originX: originX + 100, originY: originY + height / 2, height: height / 2, color: blackColor)
            // drawRotatedLetterS(context, originX: originX + 140, originY: originY + height / 2, height: height / 2, color: blackColor)
            // drawRotatedLetterB(context, originX: originX + 180, originY: originY + height / 2, height: height / 2, color: blackColor)
        }
        .background(Color.white)
    }
    
    // Функция отрисовки графического элемента (трапеция с чёрным треугольником), повёрнутого на 90°
    func drawRotatedGraphicElement(_ context: GraphicsContext, originX: CGFloat, originY: CGFloat, size: CGSize, color: Color, contextColor: Color) {
        var path = Path()
        
        // Точки для оранжевой трапеции (после поворота на 90° — это «боковой» элемент)
        path.move(to: CGPoint(x: originX, y: originY + size.height - 16))
        path.addLine(to: CGPoint(x: originX + 40, y: originY + size.height - 16))
        path.addLine(to: CGPoint(x: originX + originX + 25, y: originY + size.height - 16 + 20))
        path.addLine(to: CGPoint(x: originX + originX, y: originY + size.height - 16 + 20))
        path.closeSubpath()
        
        context.fill(path, with: .color(color))
        
//        // Чёрный треугольник внутри (после поворота — «верхняя» часть)
//        var blackPath = Path()
//        blackPath.move(to: CGPoint(x: originX, y: originY + size.height * 0.7))
//        blackPath.addLine(to: CGPoint(x: originX, y: originY))
//        blackPath.addLine(to: CGPoint(x: originX + size.width * 0.5, y: originY + size.height * 0.5))
//        blackPath.closeSubpath()
//        
//        context.fill(blackPath, with: .color(contextColor))
    }

    // Отрисовка буквы «П» линиями (повёрнута на 90°)
    func drawRotatedLetterP(_ context: GraphicsContext, originX: CGFloat, originY: CGFloat, height: CGFloat, color: Color) {
        var path = Path()
        path.move(to: CGPoint(x: originX, y: originY + height))
        path.addLine(to: CGPoint(x: originX, y: originY))  // вертикальная левая стойка
        path.addLine(to: CGPoint(x: originX + height * 0.3, y: originY))  // горизонтальная перекладина
        path.addLine(to: CGPoint(x: originX + height * 0.3, y: originY + height * 0.7))  // вертикальная правая стойка
        path.addLine(to: CGPoint(x: originX, y: originY + height * 0.7))  // нижняя перекладина
        context.stroke(path, with: .color(color), lineWidth: 10)
    }

    // Отрисовка буквы «С» линиями (повёрнута на 90°)
    func drawRotatedLetterS(_ context: GraphicsContext, originX: CGFloat, originY: CGFloat, height: CGFloat, color: Color) {
        var path = Path()
        path.move(to: CGPoint(x: originX, y: originY + height))
        path.addArc(center: CGPoint(x: originX + height * 0.5, y: originY + height * 0.5),
                    radius: height * 0.5,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        context.stroke(path, with: .color(color), lineWidth: 10)
    }

    // Отрисовка буквы «Б» линиями (повёрнута на 90°)
    func drawRotatedLetterB(_ context: GraphicsContext, originX: CGFloat, originY: CGFloat, height: CGFloat, color: Color) {
        var path = Path()
        
        // Вертикальная стойка
        path.move(to: CGPoint(x: originX, y: originY + height))
        path.addLine(to: CGPoint(x: originX, y: originY))
        
        // Верхняя перекладина
        path.addLine(to: CGPoint(x: originX + height * 0.7, y: originY))
        
        // Полукруг (правая часть «Б»)
        path.addArc(center: CGPoint(x: originX + height * 0.7, y: originY + height * 0.5),
                    radius: height * 0.35,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 360),
                    clockwise: true)
        
        // Нижняя перекладина
        path.addLine(to: CGPoint(x: originX, y: originY + height * 0.7))
        
        context.stroke(path, with: .color(color), lineWidth: 10)
    }
}

#Preview {
    ContentView()
}
