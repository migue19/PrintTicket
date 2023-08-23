//
//  ViewController.swift
//  PrintTicket
//
//  Created by MIGUEL MEXICANO HERRERA on 28/07/23.
//

import UIKit
import Printer
class ViewController: UIViewController {
    @IBOutlet weak var blockPriceSwitch: UISwitch!
    @IBOutlet weak var planSwitch: UISwitch!
    @IBOutlet weak var priceTxt: UITextField!
    private let bluetoothPrinterManager = BluetoothPrinterManager()
    private let dummyPrinter = DummyPrinter()
    private let interactor = TicketInteractor()
    override func viewDidLoad() {
        super.viewDidLoad()
        changePrice()
        disablePrice()
    }
    
    func disablePrice() {
        priceTxt.isEnabled = !blockPriceSwitch.isOn
    }
    
    func changePrice() {
        priceTxt.text = planSwitch.isOn ? "78" : "54"
    }
    
    @IBAction func printTicket(_ sender: Any) {
        guard let image = UIImage(named: "ic_logo") else {
            alert(message: "No se pudo cargar el logo")
            return
        }
        guard let date = Date().toString() else {
            alert(message: "No se pudo obtener la fecha")
            return
        }
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
            alert(message: "No estas conectado a ninguna impresora")
        }
    }
    @IBAction func connectToPrinter(_ sender: Any) {
        if bluetoothPrinterManager.canPrint {
            alert(message: "Conectado")
        } else {
            let printers = bluetoothPrinterManager.nearbyPrinters
            if printers.isEmpty {
                alert(message: "No hay impresoras disponibles")
            } else {
                for printer in printers {
                    bluetoothPrinterManager.connect(printer)
                    break
                }
            }
        }
    }
    @IBAction func blockPrice(_ sender: Any) {
        disablePrice()
    }
    @IBAction func changePlan(_ sender: Any) {
        changePrice()
    }
    @IBAction func ScanQR(_ sender: Any) {
        let scanner = ScannerViewController()
        scanner.delegate = self
        self.present(scanner, animated: true)
    }
    func alert(message: String) {
        let alert = UIAlertController(title: "Mensaje", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel))
        self.present(alert, animated: true)
    }
    func getAmount(dateString: String) -> Double {
        guard let date = dateString.toDate() else {
            return 0
        }
        let currencyDate = Date()
        let discountTime = currencyDate - date
        guard let discountTimeLeft = discountTime.second else {
            return 0
        }
        let price = 50.0
        //let days = discountTimeLeft / 86400
        var hours = discountTimeLeft / 3600 % 24
        let minutes = (discountTimeLeft % 3600) / 60
        //let seconds = (discountTimeLeft % 3600) % 60
        let amount = interactor.generatePrice(minutes: minutes)
        return amount
    }
}
extension ViewController: ScannerDelegate {
    func sendCode(code: String) {
        let result = self.storyboard?.instantiateViewController(withIdentifier: "resultView") as! ResultViewController
        let amount = getAmount(dateString: code)
        result.amount = amount
        self.navigationController?.pushViewController(result, animated: true)
    }
}
