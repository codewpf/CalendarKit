//
//  CalendarKit.swift
//  demo
//
//  Created by wpf on 2017/3/20.
//  Copyright © 2017年 wpf. All rights reserved.
//

import UIKit
import Foundation
import ObjectiveC

// MARK: - CalendarKit -
class CalendarKit {
    
}



/// 农历每日的数据
struct ChineseDayModel: CustomDebugStringConvertible {

    var year: String = ""
    var month: String = ""
    var day: String = ""
    
    init(components: DateComponents) {
        let (y,m,d) = model(from: components)
        self.year = y
        self.month = m
        self.day = d
    }
    
    private func model(from components: DateComponents) -> (String,String,String){
        
        guard let y = components.year,
              var m = components.month,
            let d = components.day else {
                return ("","","")
        }
        
        // 2057-9-28 农历会显示14-9-0 应该为14-8-30
        if d == 0 {
            m = m-1
        }

        // Heavenly Stems and Earthy Branches 天干地支
        let hs = (y % 10 == 0) ? 10 : y % 10
        let eb = (y % 12 == 0) ? 12 : y % 12
        
        let yStr = "\(self.year(from: hs, eb: eb))年"
        let mStr = "\(((components.isLeapMonth == true) ? "闰" : ""))\(self.month(from: m))月"
        let dStr = self.day(from: d)
        
        return (yStr, mStr, dStr)
    }
    
    // 天干汉字 阳干不配阴支，阴干不配阳支，所以是60年轮回
    private static let hss: [String] = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
    private static let ebs: [String] = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
    private func year(from hs: Int, eb: Int) -> String {
        guard hs <= ChineseDayModel.hss.count,
            eb <= ChineseDayModel.ebs.count else {
            return "甲子"
        }
        return "\(ChineseDayModel.hss[hs-1])\(ChineseDayModel.ebs[eb-1])"
    }
    
    private static let months: [String] = ["正", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "腊"]
    private func month(from i: Int) -> String {
        guard i <= ChineseDayModel.months.count else {
            return "正"
        }
        return ChineseDayModel.months[i-1]
    }
    
    private static let days: [String] =
        ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
         "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
         "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十",]
    private func day(from i: Int) -> String {
        guard i <= ChineseDayModel.days.count else {
            return "初一"
        }
        if i == 0 {
            return ChineseDayModel.days.last!
        }
        
        return ChineseDayModel.days[i-1]
    }

    var debugDescription: String {
        
        return "\(year)-\(month)-\(day)"
    }
    
}

/// 每天的数据
struct CKDayModel: CustomDebugStringConvertible {
    
    /// 数据是否在当前月
    enum CKDayInMonthType {
        case pre
        case current
        case sub
    }
    
    /// 提供给components计算的值
    fileprivate static let cs: Set<Calendar.Component> = [.day,.month,.year,.weekday,.weekdayOrdinal,.weekOfMonth,.weekOfYear]
    fileprivate static let chineseCS: Set<Calendar.Component> = [.day,.month,.year]
    
    /// 是否在当月
    var type: CKDayInMonthType
    /// 日期
    var date: Date
    /// 当天的值 包含cs中提供的
    var components: DateComponents?
    /// 农历当天的值 包含chineseCS中提供的
    var chineseComponents: DateComponents?
    /// 农历
    var chineseDay: ChineseDayModel?
    /// 在周内的名字
    var weekdayName: String = ""
    
    init(type: CKDayInMonthType, date: Date) {
        self.type = type
        self.date = date
        self.components = self.dateComponentsCalculate(date: date)
        self.chineseComponents = self.chineseDateComponentsCalculate(date: date)
        self.chineseDay = ChineseDayModel(components: self.chineseComponents!)
        self.weekdayName = date.weekdayName()
    }
    
    fileprivate func dateComponentsCalculate(date: Date) -> DateComponents {
        return Calendar.ckGregorian.dateComponents(CKDayModel.cs, from: date)
    }
    
    fileprivate func chineseDateComponentsCalculate(date: Date) -> DateComponents {
        return Calendar.ckChinese.dateComponents(CKDayModel.chineseCS, from: date)
    }
    
    var debugDescription: String {
        guard let year = self.components?.year,
            let month = self.components?.month,
            let day = self.components?.day,
            let cYear = self.chineseComponents?.year,
            let cMonth = self.chineseComponents?.month,
            let cDay = self.chineseComponents?.day else {
                return "type = \(self.type)"
        }
        return "type = \(self.type), components = \(year)-\(month)-\(day), chinese = \(cYear)-\(cMonth)-\(cDay), day = \(self.chineseDay!.year)\(self.chineseDay!.month)\(self.chineseDay!.day) weedayName = \(self.weekdayName)\n"
    }
}

// MARK: - CalendarKit Extension -

/// 自定义格里高利历（或称公历）和农历
/// - Kit计算过程中只使用一下两个历法。公历为主要计算历法，农历是计算农历相关的日期与节日
extension Calendar {
    
    /// CalendarKit Day时间戳
    static let dayInterval: Double = 86400 // 24 * 60 * 60
    
    fileprivate static var _ckGregorian: Calendar = Calendar(identifier: .gregorian)
    /// CalendarKit 格里高利历
    static var ckGregorian: Calendar {
        get{
            return _ckGregorian
        }
    }
    fileprivate static var _ckChinese: Calendar = Calendar(identifier: .chinese)
    /// CalendarKit 农历
    static var ckChinese: Calendar {
        get{
            return _ckChinese
        }
    }
    /// 周第一天
    enum FirstWeekDayType: Int {
        case sun = 1, mon, tue, wed, thr, fri, sat
    }
    
    // 以下根据周第一天设置名字数组
    private static let wdnames = [Bundle.ckLocalizeString(key: "Day1") ?? "Sun",
                                  Bundle.ckLocalizeString(key: "Day2") ?? "Mon",
                                  Bundle.ckLocalizeString(key: "Day3") ?? "Tue",
                                  Bundle.ckLocalizeString(key: "Day4") ?? "Wed",
                                  Bundle.ckLocalizeString(key: "Day5") ?? "Thu",
                                  Bundle.ckLocalizeString(key: "Day6") ?? "Fri",
                                  Bundle.ckLocalizeString(key: "Day7") ?? "Sat"]
    static var ckWeekdayNames: [String] = []
    
    /// cCalendarKit 第一个工作日
    static var ckFirstWeekday: FirstWeekDayType {
        get {
            return Calendar.FirstWeekDayType(rawValue: Calendar.ckGregorian.firstWeekday)!
        }
        set {
            _ckGregorian.firstWeekday = newValue.rawValue
            _ckChinese.firstWeekday = newValue.rawValue
            
            var names: [String] = []
            var k: Int = newValue.rawValue - 1
            for _ in 0 ..< 7 {
                names.append(self.wdnames[k])
                k = k+1
                if k == 7 {
                    k = 0
                }
            }
            
            self.ckWeekdayNames = names
        }
    }
    
    /// CalendarKit 时区
    static var ckTimeZone: TimeZone {
        get {
            return _ckGregorian.timeZone
        }
    }
    
}



/// Date计算相关的方法
/// - 以下方法全部都进行百万次计算，选择时间最优的方法或者自定义方法
extension Date {
    
    /// 获取当前日所在月的天数
    ///
    /// - Returns: 当前月天数
    func daysInMonth() -> Int {
        guard let di = Calendar.ckGregorian.dateInterval(of: .month, for: self) else {
            return 0
        }
        return Int(di.duration / Calendar.dayInterval)
    }
    
    /// 获取距离当前月数的日期
    ///
    /// - Parameter: interval 月数间隔
    /// - Returns: 日期
    func dayByInterval(months interval: Int) -> Date {
        guard let date = Calendar.ckGregorian.date(byAdding: .month, value: interval, to: self, wrappingComponents: false) else {
            return self
        }
        return date
    }
    
    /// 获取距离当前周数的日期
    ///
    /// - Parameter: interval 周数间隔
    /// - Returns: 日期
    func dayByInterval(weeks interval: Double) -> Date {
        return self.dayByInterval(days: interval * 7)
    }
    
    /// 获取距离当前天数的日期
    ///
    /// - Parameter: interval 天数间隔
    /// - Returns: 日期
    func dayByInterval(days interval: Double) -> Date {
        return self.addingTimeInterval(TimeInterval(Calendar.dayInterval * interval))
    }
    
    /// 获取当前日所在月的 每一天的数据
    ///
    /// - Returns: 当月的每一天的数据
    func modelInMonth() -> [CKDayModel] {
        // di.start 本月1号0点 di.end下月1号0点
        guard let di = Calendar.ckGregorian.dateInterval(of: .month, for: self),
            let startInWeek = Calendar.ckGregorian.ordinality(of: .day, in: .weekOfMonth, for: di.start),
            let endInWeek = Calendar.ckGregorian.ordinality(of: .day, in: .weekOfMonth, for: di.end) else {
                return []
        }
        
        var result: [CKDayModel] = []
        // 计算当前月第一周包含上月的数据，如果第一天是FirstWeekday就不再计算
        
        print(startInWeek)
        if startInWeek >= 2 {
            for i in 1 ... startInWeek - 1 {
                let model: CKDayModel = CKDayModel(type: .pre, date: di.start.dayByInterval(days: Double(-1 * i)))
                result.insert(model, at: 0)
            }
        }
        
        // 计算当前月 的数据
        for i in 0 ..< Int(di.duration / Calendar.dayInterval) {
            let model: CKDayModel = CKDayModel(type: .current, date: di.start.dayByInterval(days: Double(i)))
            result.append(model)
        }
        
        // 计算当前月最后一周包含下月的数据，如果是下个月第一天是FirstWeekday就不算在最后一周。
        if endInWeek > 1 {
            for i in 0 ..< 7 + 1 - endInWeek {
                let model: CKDayModel = CKDayModel(type: .sub, date: di.end.dayByInterval(days: Double(i)))
                result.append(model)
            }
        }
        return result
    }
    
    /// 周名称
    func weekdayName() -> String {
        guard let index = Calendar.ckGregorian.ordinality(of: .day, in: .weekOfMonth, for: self) else {
            return "error name"
        }
        
        guard Calendar.ckWeekdayNames.count == 7  else {
            return "\(index)"
        }

        return Calendar.ckWeekdayNames[index-1]
    }

    fileprivate static let _ckFromatter = DateFormatter()
    /// Date to String
    ///
    /// - Parameters:
    ///   - date: 日期
    ///   - format: 格式 (yyyy-MM-dd)
    ///   - timezome: 时区 (TimeZone.current)
    /// - Returns: 对应字符串
    func string(from date: Date, format: String = "yyyy-MM-dd", timezome: TimeZone = TimeZone.current) -> String{
        Date._ckFromatter.dateFormat = format
        Date._ckFromatter.timeZone = timezome
        return Date._ckFromatter.string(from: date)
    }
    /// String to Date
    ///
    /// - Parameters:
    ///   - string: 字符串
    ///   - format: 格式 (yyyy-MM-dd)
    ///   - timezome: 时区 (TimeZone.current)
    /// - Returns: 对应日期
    func date(from string: String, format: String = "yyyy-MM-dd", timezome: TimeZone = TimeZone.current) -> Date? {
        Date._ckFromatter.dateFormat = format
        Date._ckFromatter.timeZone = timezome
        return Date._ckFromatter.date(from: string)
    }
    
    
}







