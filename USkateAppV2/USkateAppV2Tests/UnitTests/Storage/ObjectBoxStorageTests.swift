//
//  ObjectBoxStorageTests.swift
//  USkateAppV2Tests
//
//  Created by Oleg Bragin on 16.02.2026.
//

import Foundation
import Testing
import ObjectBox
@testable import USkateAppV2  // замените на имя вашего модуля

import Testing
import ObjectBox
@testable import USkateAppV2  // замените на имя вашего модуля

// Вспомогательные данные для тестов
private struct TestData {
    static let calendarName = "Test Calendar"
    static let calendarYear = 2026
    
    static func createTestCalendar(with id: UInt64 = 0) -> CalendarDataSource {
        CalendarDataSource(
            id: id,
            name: calendarName,
            year: calendarYear
        )
    }
}

// Структура для группировки тестов (без @TestSuite)
@Suite("Lower storage tests")
@MainActor
final class ObjectBoxCalendarStorageTests {
    private var storage: ObjectBoxCalendarStorage!
    
    private func setUp() throws {
        storage = ObjectBoxCalendarStorage(directory: testStoragePath())
    }
    
    private func tearDown() {
        storage.close()
    }
    
    private func testStoragePath() -> URL {
        let databaseName = "calendars_\(UUID())"
        let appSupport = try! FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true)
            .appendingPathComponent(Bundle.main.bundleIdentifier!
        )
        let directory = appSupport.appendingPathComponent(databaseName)
        try! FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true,
            attributes: nil
        )
        return directory
    }
        
    // Тест получения существующего календаря
    @Test func testGetCalendar() async throws {
        try setUp()
        let testCalendar = TestData.createTestCalendar()
        let newlyCreatedCalendarid = try await storage.saveCalendar(testCalendar)
        let fetchedCalendar = try await storage.getCalendar(id: newlyCreatedCalendarid)
        #expect(fetchedCalendar != nil)
        #expect(fetchedCalendar!.id == newlyCreatedCalendarid)
        #expect(fetchedCalendar!.name == testCalendar.name)
        #expect(fetchedCalendar!.year == testCalendar.year)
        tearDown()
    }
    
    // Тест получения несуществующего календаря
    @Test func testGetNonExistentCalendar() async throws {
        try setUp()
        let nonExistentId: UInt64 = 999
        let result = try await storage.getCalendar(id: nonExistentId)
        #expect(result == nil)
        tearDown()
    }
    
    // Тест удаления календаря
    @Test func testDeleteCalendar() async throws {
        try setUp()
        var testCalendar = TestData.createTestCalendar()
        let newlyCreatedCalendarid = try await storage.saveCalendar(testCalendar)
        testCalendar.id = newlyCreatedCalendarid
        
        let deletedCalendarid = try await storage.deleteCalendar(testCalendar)
        let deletedCalendar = try await storage.getCalendar(id: deletedCalendarid)
        #expect(deletedCalendar == nil)
        tearDown()
    }
    // Тест удаления несуществующего календаря (не должно быть ошибки)
    @Test func testDeleteNonExistentCalendar() async throws {
        try setUp()
        let nonExistentCalendar = CalendarDataSource(id: 999, name: "Non-existent", year: 2026)
        try await storage.deleteCalendar(nonExistentCalendar)
        // Тест пройден, если не выброшено исключение
        #expect(true)
        tearDown()
    }
    // Тест получения всех календарей (непустая БД)
    @Test func testGetAllCalendars() async throws {
        try setUp()
        let calendar1 = CalendarDataSource(name: "Calendar 1", year: 2026)
        let calendar2 = CalendarDataSource(name: "Calendar 2", year: 2027)
        try await storage.saveCalendar(calendar1)
        try await storage.saveCalendar(calendar2)
        let allCalendars = try await storage.getAllCalendars()
        #expect(allCalendars.count == 2)
        let names = allCalendars.map { $0.name }.sorted()
        #expect(names == ["Calendar 1", "Calendar 2"])
        let years = allCalendars.map { $0.year }.sorted()
        #expect(years == [2026, 2027])
        tearDown()
    }
    // Тест получения всех календарей (пустая БД)
    @Test func testEmptyGetAllCalendars() async throws {
        try setUp()
        let allCalendars = try await storage.getAllCalendars()
        #expect(allCalendars.isEmpty)
        tearDown()
    }
    // Тест обновления существующего календаря
    @Test func testUpdateExistingCalendar() async throws {
        try setUp()
        let testCalendar = TestData.createTestCalendar()
        let newlyCreatedCalendarid = try await storage.saveCalendar(testCalendar)
        let updatedCalendar = CalendarDataSource(
            id: newlyCreatedCalendarid,
            name: "Updated Calendar",
            year: 2027
        )
        try await storage.saveCalendar(updatedCalendar)
        let fetchedCalendar = try await storage.getCalendar(id: newlyCreatedCalendarid)
        #expect(fetchedCalendar != nil)
        #expect(fetchedCalendar!.name == "Updated Calendar")
        #expect(fetchedCalendar!.year == 2027)
        tearDown()
    }
    // Тест последовательности операций
    @Test func testMultipleOperations() async throws {
        try setUp()
        var calendar1 = CalendarDataSource(name: "First", year: 2025)
        var calendar2 = CalendarDataSource(name: "Second", year: 2028)
        let newlyCreatedCalendarid1 = try await storage.saveCalendar(calendar1)
        calendar1.id = newlyCreatedCalendarid1
        let newlyCreatedCalendarid2 = try await storage.saveCalendar(calendar2)
        calendar2.id = newlyCreatedCalendarid2
        try await storage.deleteCalendar(calendar1)
        let remaining = try await storage.getAllCalendars()
        #expect(remaining.count == 1)
        #expect(remaining[0].id == calendar2.id)
        tearDown()
    }
}
