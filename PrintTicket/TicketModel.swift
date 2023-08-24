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
}
struct PriceInformation {
    var unlimitedPriceDay: Double
    var limitedPriceDay: Double
    var unlimitedPriceHour: Double
    var limitedPriceHour: Double
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
