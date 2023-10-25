//
//  Bundle.swift
//  PrintTicket
//
//  Created by Miguel Mexicano Herrera on 25/10/23.
//
import Foundation
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
