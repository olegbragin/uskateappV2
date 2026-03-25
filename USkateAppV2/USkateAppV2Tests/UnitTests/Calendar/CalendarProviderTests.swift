//
//  CalendarProviderTests.swift
//  USkateAppV2Tests
//
//  Created by Oleg Bragin on 23.03.2026.
//

import Testing
import Foundation
@testable import USkateAppV2

@Suite("USCalendarProvider Tests")
struct USCalendarProviderTests {
    
    @Test("First letters of weekdays are correct for US locale")
    func testFirstLettersOfLocalizedWeekdaysUS() {
        let calendar = Calendar(identifier: .gregorian)
        let provider = USCalendarDataProvider(calendar: calendar)
        let month = provider.months(forYear: 2024)[0]
        
        #expect(month.weekDaySymbols == ["S", "M", "T", "W", "T", "F", "S"])
    }
    
    @Test("First letters with Monday as first day of week")
    func testFirstLettersWithMondayAsFirstDay() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US")
        calendar.firstWeekday = 2
        
        let provider = USCalendarDataProvider(calendar: calendar)
        let month = provider.months(forYear: 2024)[0]
        
        #expect(month.weekDaySymbols == ["M", "T", "W", "T", "F", "S", "S"])
    }
    
    @Test("Months for year return exactly 12 months")
    func testMonthsForYearReturns12Months() {
        let provider = USCalendarDataProvider()
        let months = provider.months(forYear: 2024)
        
        #expect(months.count == 12)
        #expect(months[0].number == 1)
        #expect(months[11].number == 12)
    }
    
    @Test("Month labels are correctly localized")
    func testMonthLabelsLocalizedCorrectly() {
        let provider = USCalendarDataProvider()
        let months = provider.months(forYear: 2024)
        
        #expect(months[0].label == "January")
        #expect(months[5].label == "June")
        #expect(months[11].label == "December")
    }
    
    @Test("Weeks for month contain correct number of weeks (4–6)")
    func testWeeksForMonthCount() {
        let provider = USCalendarDataProvider()
        let months = provider.months(forYear: 2024)
        let weeks = months[1].weeks
        
        #expect(weeks.count >= 4)
        #expect(weeks.count <= 6)
    }
    
    @Test("First week contains correct days for January 2024")
    func testFirstWeekContainsCorrectDays() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale.autoupdatingCurrent
        let provider = USCalendarDataProvider(calendar: calendar)
        let months = provider.months(forYear: 2024)
        let weeks = months[0].weeks
        let firstWeek = weeks[0]
        #expect(firstWeek.days.count == 7)
        
        // 1 января 2024 — понедельник
        #expect(firstWeek.days[0].number == 1)
        #expect(firstWeek.days[6].number == 7)
    }
    
    @Test("Last week of February 2024 (leap year) contains 29th day")
    func testLastWeekFebruaryLeapYear() {
        let provider = USCalendarDataProvider()
        let months = provider.months(forYear: 2024)
        let weeks = months[1].weeks
        let allDays = weeks.flatMap { $0.days }
        #expect(allDays.contains { $0.number == 29 })
    }
    
    @Test("Today's date is correctly marked in current month")
    func testTodayIsMarkedCorrectly() {
        let testDate = Date()
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale.autoupdatingCurrent
        let currentMonth = calendar.component(.month, from: testDate)
        let currentYear = calendar.component(.year, from: testDate)
        
        let provider = USCalendarDataProvider(calendar: calendar)
        let months = provider.months(forYear: currentYear)
        let weeks = months[currentMonth - 1].weeks
        
        let todayInWeeks = weeks.flatMap { $0.days }.first { $0.isToday }
        
        #expect(todayInWeeks != nil)
        #expect(todayInWeeks?.number == calendar.component(.day, from: testDate))
    }
}
