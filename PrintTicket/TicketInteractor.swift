//
//  TicketInteractor.swift
//  PrintTicket
//
//  Created by MIGUEL MEXICANO HERRERA on 22/08/23.
//

import Foundation

final class TicketInteractor {
    ///Funcion que retorna el precio por tiempo
    /// 1.- Primeros 15 minutos no se cobran
    /// 2.- Apartir del minuto 16 se cobra por minuto
    func generatePrice(minutes: Int) -> Double {
        let price = 50.0
        let pricePerMinute = price / 60
        if minutes > 15 {
            return Double(minutes) * pricePerMinute
        } else {
            return 0
        }
    }
}
