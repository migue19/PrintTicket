//
//  Date.swift
//  PrintTicket
//
//  Created by Miguel Mexicano Herrera on 02/08/23.
//
import Foundation
extension Date {
    func toString(dateFormat: String = "yyyy-MM-dd HH:mm:ss", locale: Locale = Locale(identifier: "es_MX")) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second
        
        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
}
