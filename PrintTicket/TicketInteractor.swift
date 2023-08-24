//
//  TicketInteractor.swift
//  PrintTicket
//
//  Created by MIGUEL MEXICANO HERRERA on 22/08/23.
//

import Foundation

final class TicketInteractor {
    ///Función que retorna el precio por tiempo
    /// 1.- Primeros 15 minutos no se cobran
    /// 2.- A partir del minuto 16 se cobra por minuto
    /// 3.- Después de la hora 4 se cobra el dia
    func generatePrice(hours: Int, minutes: Int, price: Double) -> Double {
        let pricePerMinute = price / 60.0
        if minutes > 15 {
            return Double(minutes) * pricePerMinute
        } else {
            return 0
        }
    }
}
