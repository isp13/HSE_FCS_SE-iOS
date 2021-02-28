//
//  dateSupport.swift
//  Task-list
//
//  Created by Никита Казанцев on 27.02.2021.
//  Copyright © 2021 Sinapsic. All rights reserved.
//


import Foundation

extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var startOfMonth: Date {
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return  calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
    
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    func getFormattedDate(_ format: String = "dd.MM", dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        dateformat.dateStyle = dateStyle
        dateformat.timeStyle = timeStyle
        dateformat.timeZone = TimeZone.current
        dateformat.locale = Locale.init(identifier: Locale.preferredLanguages.first!)
        
        

        return dateformat.string(from: self)
    }
    


func UTCtoClockTimeOnly(currentDate: Date, format: String = "HH:mm") -> String {
    // 4) Set the current date, altered by timezone.
    let dateString = currentDate.getFormattedDate(format: format)
    return dateString
}

/**
 получение длительности сна как строка + форматирование с добавлением ведущих нулей когда нужно
 */
func MinutesToDateDescription(minutes: Int) -> String {
    let hours = minutes / 60
    let minutes = minutes % 60
    let minutesStr = minutes > 9 ? String(minutes) : "0" + String(minutes)
    
    return "\(hours):\(minutesStr)"
}
}



