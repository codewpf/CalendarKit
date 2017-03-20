//
//  CalendarKit.swift
//  demo
//
//  Created by wpf on 2017/3/20.
//  Copyright © 2017年 wpf. All rights reserved.
//

import UIKit
import Foundation

// MARK: - CalendarKit -

class CalendarKit: NSObject {

}


/// 数据是否在当前月
enum DayInMonthType {
    case pre, current, sub
}

/// 每天的数据
struct DayModel: CustomDebugStringConvertible {
    
    /// 提供给componments计算的值
    static let cs: Set<Calendar.Component> = [.day,.month,.year,.weekday,.weekdayOrdinal,.weekOfMonth,.weekOfYear]
    
    /// 是否在当月
    var type: DayInMonthType
    /// 当天的值 包含cs中提供的
    var componments: DateComponents?
    
    init(type: DayInMonthType) {
        self.type = type
    }
    
    var debugDescription: String {
        guard let year = self.componments?.year,
            let month = self.componments?.month,
            let day = self.componments?.day else {
                return "type = \(self.type)"
        }
        return "type = \(self.type), componments = \(year)-\(month)-\(day)\n"
    }
}

// MARK: - Extension -

/// 自定义格里高利历（或称公历）和农历
/// - Kit计算过程中只使用一下两个历法。公历为主要计算历法，农历是用来计算农历相关的日期与节日
extension Calendar {
    
    /// CalendarKit Day时间戳
    static let dayInterval: Double = 86400 // 24 * 60 * 60
    
    private static var _ckGregorian: Calendar = Calendar(identifier: .gregorian)
    /// CalendarKit 格里高利历
    static var ckGregorian: Calendar {
        get{
            return _ckGregorian
        }
    }
    private static var _ckChinese: Calendar = Calendar(identifier: .chinese)
    /// CalendarKit 农历
    static var ckChinese: Calendar {
        get{
            return _ckChinese
        }
    }
    
    /// cCalendarKit 第一个工作日
    static var ckFirstWeekday: Int {
        get {
            return Calendar.ckGregorian.firstWeekday
        }
        set {
            _ckGregorian.firstWeekday = newValue
            _ckChinese.firstWeekday = newValue
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
    func daysInMonth() -> Int {
        guard let di = Calendar.ckGregorian.dateInterval(of: .month, for: self) else {
            return 0
        }
        return Int(di.duration / Calendar.dayInterval)
    }
    
    /// 获取距离当前周数的日期
    func dayByInterval(weeks interval: Double) -> Date {
        return self.dayByInterval(days: interval * 7)
    }
    
    /// 获取距离当前天数的日期
    func dayByInterval(days interval: Double) -> Date {
        return self.addingTimeInterval(TimeInterval(Calendar.dayInterval * interval))
    }
    
    /// 获取当前日所在月的 每一天的数据
    func modelInMonth() -> [DayModel] {
        // di.start 本月1号0点 di.end下月1号0点
        guard let di = Calendar.ckGregorian.dateInterval(of: .month, for: self),
            let startInWeek = Calendar.ckGregorian.ordinality(of: .day, in: .weekOfMonth, for: di.start),
            let endInWeek = Calendar.ckGregorian.ordinality(of: .day, in: .weekOfMonth, for: di.end) else {
                return []
        }
        
        var result: [DayModel] = []
        // 计算当前月第一周包含上月的数据，如果第一天是周一就不再计算
        if startInWeek > 2 {
            for i in 1 ... startInWeek - 1 {
                var model: DayModel = DayModel(type: .pre)
                model.componments = Calendar.ckGregorian.dateComponents(DayModel.cs, from: di.start.dayByInterval(days: Double(-1 * i)))
                result.insert(model, at: 0)
            }
        }
        
        // 计算当前月 的数据
        for i in 0 ..< Int(di.duration / Calendar.dayInterval) {
            var model: DayModel = DayModel(type: .current)
            model.componments = Calendar.ckGregorian.dateComponents(DayModel.cs, from: di.start.dayByInterval(days: Double(i)))
            result.append(model)
        }
        
        // 计算当前月最后一周包含下月的数据，如果是下个月第一天是周一就不算在最后一周。
        if endInWeek > 1 {
            for i in 0 ..< 7 + 1 - endInWeek {
                var model: DayModel = DayModel(type: .sub)
                model.componments = Calendar.ckGregorian.dateComponents(DayModel.cs, from: di.start.dayByInterval(days: Double(i)))
                result.append(model)
            }
        }
        return result
    }
    
    private static let _ckFromatter = DateFormatter()
    /// Date to String
    func string(from date: Date, format: String = "yyyy-MM-dd", timezome: TimeZone = TimeZone.current) -> String{
        Date._ckFromatter.dateFormat = format
        Date._ckFromatter.timeZone = timezome
        return Date._ckFromatter.string(from: date)
    }
    /// String to Date
    func date(from string: String, format: String = "yyyy-MM-dd", timezome: TimeZone = TimeZone.current) -> Date? {
        Date._ckFromatter.dateFormat = format
        Date._ckFromatter.timeZone = timezome
        return Date._ckFromatter.date(from: string)
    }

    
}







