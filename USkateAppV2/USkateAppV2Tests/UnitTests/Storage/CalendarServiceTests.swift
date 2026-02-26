//
//  CalendarServiceTests.swift
//  USkateAppV2Tests
//
//  Created by Oleg Bragin on 17.02.2026.
//

import Foundation
import Testing
@testable import USkateAppV2

// Вспомогательные данные
private struct TestData {
    static var calendarId: UInt64 = 0
    static let calendarName = "Test Calendar"
    static let calendarYear = 2026
    
    static func createCalendar() -> CalendarDataSource {
        CalendarDataSource(
            id: calendarId,
            name: calendarName,
            year: calendarYear,
            events: []
        )
    }
    
    static func createEvent() -> EventDataSource? {
        EventDataSource(name: "Test Event", date: Date(), color: "Black")
    }
}

// Мокируем хранилище для изоляции тестов
private class MockCalendarStorage: CalendarStorage {
    var calendars: [CalendarDataSource] = []
    
    func getCalendar(id: UInt64) async throws -> CalendarDataSource? {
        calendars.first { $0.id == id }
    }
    
    func saveCalendar(_ calendar: CalendarDataSource) async throws -> UInt64 {
        if let index = calendars.firstIndex(where: { $0.id == calendar.id }) {
            calendars[index] = calendar
        } else {
            calendars.append(calendar)
        }
        return calendar.id
    }
    
    func deleteCalendar(_ calendar: CalendarDataSource) async throws -> UInt64 {
        guard let calendarToRemoveindex = calendars.firstIndex(where: { $0.id == calendar.id }) else { return 0 }
        return calendars.remove(at: calendarToRemoveindex).id
    }
    
    func getAllCalendars() async throws -> [CalendarDataSource] {
        calendars
    }
}

// Структура для тестов
@MainActor
@Suite("Service tests")
final class CalendarServiceTests {
    private var service: CalendarService!
    private var mockStorage: MockCalendarStorage!
    private var buffer: CalendarBuffer!
    
    private func setUp() {
        mockStorage = MockCalendarStorage()
        buffer = CalendarBuffer()
        service = CalendarService(storage: mockStorage, buffer: buffer)
    }
    
    // Тест создания календаря
    @Test func testCreateCalendar() {
        setUp()
        let calendar = service.createCalendar(name: "New", year: 2027)
        #expect(calendar.name == "New")
        #expect(calendar.year == 2027)
        #expect(buffer.getAll().count == 1)
        #expect(buffer.getAll()[0].id == calendar.id)
    }
    
    // Тест получения календаря (из буфера)
    @Test func testGetCalendarFromBuffer() async throws {
        setUp()
        let calendar = TestData.createCalendar()
        buffer.add(calendar)
        
        let result = try await service.getCalendar(id: calendar.id)
        #expect(result != nil)
        #expect(result!.id == calendar.id)
    }
    
    // Тест получения календаря (из хранилища)
    @Test func testGetCalendarFromStorage() async throws {
        setUp()
        let calendar = TestData.createCalendar()
        try await mockStorage.saveCalendar(calendar)
        
        let result = try await service.getCalendar(id: calendar.id)
        #expect(result != nil)
        #expect(result!.id == calendar.id)
    }
    
    // Тест обновления календаря
    @Test func testUpdateCalendar() {
        setUp()
        let calendar = TestData.createCalendar()
        buffer.add(calendar)
        
        service.updateCalendar(calendar, name: "Updated", year: 2028)
        let updated = buffer.getAll().first { $0.id == calendar.id }
        
        #expect(updated != nil)
        #expect(updated!.name == "Updated")
        #expect(updated!.year == 2028)
    }
    
    // Тест удаления календаря
    @Test func testDeleteCalendar() {
        setUp()
        let calendar = TestData.createCalendar()
        buffer.add(calendar)
        
        service.deleteCalendar(calendar)
        let remaining = buffer.getAll()
        
        #expect(remaining.isEmpty)
    }
    
    // Тест сохранения буфера в хранилище (flush)
    @Test func testFlush() async throws {
        setUp()
        let calendar = TestData.createCalendar()
        buffer.add(calendar)
        
        try await service.flush()
        let saved = try await mockStorage.getCalendar(id: calendar.id)
        
        #expect(saved != nil)
        #expect(saved!.id == calendar.id)
        #expect(buffer.getAll().isEmpty)  // буфер очищен
    }
    
    // Тест добавления события в календарь
    @Test func testAddEvent() {
        setUp()
        let calendar = TestData.createCalendar()
        buffer.add(calendar)
        let event = TestData.createEvent()
        
        service.addEvent(to: calendar, event: event)
        let updatedCalendar = buffer.getAll().first { $0.id == calendar.id }
        
        #expect(updatedCalendar?.events.count == 1)
        #expect(updatedCalendar?.events[0].id == event?.id)
    }
    
    // Тест удаления события из календаря
    @Test func testRemoveEvent() {
        setUp()
        var calendar = TestData.createCalendar()
        let event = TestData.createEvent()
        if let event {
            calendar.events.append(event)
        }
        buffer.add(calendar)
        
        service.removeEvent(from: calendar, event: calendar.events[0])
        let updatedCalendar = buffer.getAll().first { $0.id == calendar.id }
        
        #expect(updatedCalendar?.events.isEmpty ?? false)
    }
    
    // Тест работы с событиями при пустом списке
    @Test func testAddEventToEmptyCalendar() {
        setUp()
        let calendar = CalendarDataSource(id: 2, name: "Empty", year: 2026)
        buffer.add(calendar)
        let event = TestData.createEvent()
        
        service.addEvent(to: calendar, event: event)
        let updatedCalendar = buffer.getAll().first { $0.id == calendar.id }
        
        #expect(updatedCalendar?.events.count == 1)
    }
}
