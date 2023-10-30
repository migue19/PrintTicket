//
//  TicketModel.swift
//  PrintTicket
//
//  Created by Miguel Mexicano Herrera on 24/08/23.
//

import Foundation

struct DateInformation {
    var days: Int
    var hours: Int
    var minutes: Int
    var seconds: Int
    var discountTime: (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?)
}
struct PriceInformation {
    var priceDay: Double
    var priceHour: Double
}
enum PlanType {
    case limited
    case unlimited
}
struct ResultModel {
    var dateInformation: DateInformation
    var planType: PlanType
    var priceInformation: PriceInformation
}
enum PriceType {
    case day
    case hour
    case zero
}
