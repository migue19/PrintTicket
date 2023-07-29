//
//  ViewController.swift
//  PrintTicket
//
//  Created by MIGUEL MEXICANO HERRERA on 28/07/23.
//

import UIKit
import Printer
class ViewController: UIViewController {
    private let bluetoothPrinterManager = BluetoothPrinterManager()
    private let dummyPrinter = DummyPrinter()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func printTicket(_ sender: Any) {
        guard let image = UIImage(named: "ic_logo") else {
            return
        }
        let date = Date().description
        let ticket = Ticket(
            .title("WorkLine"),
            .text(.init(content: "Bienvenido", predefined: .bold, .alignment(.center))),
            .image(image, attributes: .alignment(.center)),
            .text(.init(content: date, predefined: .alignment(.center))),
            .dividing(),
            Block(Text(content: "Gracias por tu preferencia", predefined: .alignment(.center))),
            .qr(date)
        )
        if bluetoothPrinterManager.canPrint {
            bluetoothPrinterManager.print(ticket)
        } else {
            let printers = bluetoothPrinterManager.nearbyPrinters
            for printer in printers {
                bluetoothPrinterManager.connect(printer)
                break
            }
        }
    }
}
