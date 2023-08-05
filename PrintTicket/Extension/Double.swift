//
//  Double.swift
//  PrintTicket
//
//  Created by Miguel Mexicano Herrera on 02/08/23.
//
import Foundation
extension Double {
    var currency: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: NSNumber(value: self))
    }
}
