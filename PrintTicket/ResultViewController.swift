//
//  ResultViewController.swift
//  PrintTicket
//
//  Created by Miguel Mexicano Herrera on 02/08/23.
//

import UIKit
import NutUtils
class ResultViewController: UIViewController {
    @IBOutlet weak var completeDayLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    var resultModel: ResultModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dateInformation = resultModel?.dateInformation {
            daysLabel.text = "\(dateInformation.days)"
            hoursLabel.text = "\(dateInformation.hours)"
            minutesLabel.text = "\(dateInformation.minutes)"
            secondsLabel.text = "\(dateInformation.seconds)"
        }
        validateInformation()
    }
    func validateInformation() {
        guard let resultModel = resultModel else {
            return
        }
        let dateInformation = resultModel.dateInformation
        if dateInformation.days >= 1 {
            completeDayLabel.isHidden = true
            alertWithDelay(message: "No puedes exceder mas de un Día")
            return
        }
        if dateInformation.hours >= 4 {
            completeDayLabel.isHidden = false
            let price = resultModel.planType == .unlimited ? resultModel.priceInformation.unlimitedPriceDay : resultModel.priceInformation.limitedPriceDay
            if let currency = price.currency {
                textLabel.text = currency
            } else {
                textLabel.text = "No se obtuvo el monto"
            }
        } else {
            completeDayLabel.isHidden = true
            let discountTime = resultModel.dateInformation.discountTime
            let minutes = discountTime.minute ?? 0
            let price = resultModel.planType == .unlimited ? resultModel.priceInformation.unlimitedPriceHour : resultModel.priceInformation.limitedPriceHour
            let pricePerMinute = price / 60
            let totalPrice = Double(minutes) * pricePerMinute
            if let currency = totalPrice.currency {
                textLabel.text = currency
            } else {
                textLabel.text = "No se obtuvo el monto"
            }
        }
    }
    func alert(message: String) {
        let alert = UIAlertController(title: "Mensaje", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel))
        self.present(alert, animated: true)
    }
    func alertWithDelay(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.alert(message: message)
        }
    }
}
