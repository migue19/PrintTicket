//
//  ViewController.swift
//  PrintTicket
//
//  Created by MIGUEL MEXICANO HERRERA on 28/07/23.
//

import UIKit
import Printer
import NutUtils
class ViewController: UIViewController {
    let unlimitedPriceHour = 78.0
    let limitedPriceHour = 54.0
    let unlimitedPriceDay = 349.0
    let limitedPriceDay = 216.0
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
        priceTxt.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    func disablePrice() {
        priceTxt.isEnabled = !blockPriceSwitch.isOn
    }
    
    func changePrice() {
        priceTxt.text = planSwitch.isOn ? unlimitedPriceHour.currency : limitedPriceHour.currency
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
    
    func getDateInformation(dateString: String) -> DateInformation? {
        guard let date = dateString.toDate() else {
            return nil
        }
        let currencyDate = Date()
        let discountTime = currencyDate - date
        guard let discountTimeLeft = discountTime.second else {
            return nil
        }
        let days = discountTimeLeft / 86400
        let hours = discountTimeLeft / 3600 % 24
        let minutes = (discountTimeLeft % 3600) / 60
        let seconds = (discountTimeLeft % 3600) % 60
        return DateInformation(days: days, hours: hours, minutes: minutes, seconds: seconds)
    }
    
//    func getAmount(dateString: String) -> Double {
//        let amount = interactor.generatePrice(hours: hours, minutes: minutes, price: price)
//        return amount
//    }
    func alertWithDelay(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            self?.alert(message: message)
        }
    }
}
extension ViewController: ScannerDelegate {
    func showResultView(amount: Double, dateInformation: DateInformation) {
        let result = self.storyboard?.instantiateViewController(withIdentifier: "resultView") as! ResultViewController
        result.amount = amount
        result.dateInformation = dateInformation
        self.navigationController?.pushViewController(result, animated: true)
    }
    func sendCode(code: String) {
        //let code = "2023-08-02 16:43:34"
        let code = "2023-08-24 05:00:34"
        guard let dateInformation = getDateInformation(dateString: code) else {
            alertWithDelay(message: "El QR es invalido")
            return
        }
        if dateInformation.days >= 1 {
            alertWithDelay(message: "No puedes exceder mas de un Día")
            return
        }
        if dateInformation.hours > 4 {
            let price = planSwitch.isOn ? unlimitedPriceDay : limitedPriceDay
            showResultView(amount: price, dateInformation: dateInformation)
        }
    }
}
extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        priceTxt.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let amount: Double = Double(textField.text ?? "0") ?? 0.0
        priceTxt.text = amount.currency
    }
}
struct DateInformation {
    var days: Int
    var hours: Int
    var minutes: Int
    var seconds: Int
}
