//
//  ResultViewController.swift
//  PrintTicket
//
//  Created by Miguel Mexicano Herrera on 02/08/23.
//

import UIKit
import NutUtils
class ResultViewController: UIViewController {
    let tolerance: Int = 15
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
        let planType = resultModel.planType
        let priceInformation = resultModel.priceInformation
        let dateInformation = resultModel.dateInformation
        let minutes = dateInformation.minutes
        if dateInformation.days >= 1 {
            completeDayLabel.isHidden = true
            alertWithDelay(message: "No puedes exceder mas de un Día")
            return
        }
        if dateInformation.hours >= 4 {
            completeDayLabel.isHidden = false
            let price =
            if let currency = price.currency {
                textLabel.text = currency
            } else {
                textLabel.text = "No se obtuvo el monto"
            }
        } else {
            completeDayLabel.isHidden = true
            if minutes > tolerance {
                if minutes > 60 {
                    getAmount(minutes: minutes, planType: <#PlanType#>, price: <#Double#>)
                }
                
            } else {
                textLabel.text = 0.currency ?? ""
            }
        }
    }
    func getAmount(minutes: Int, planType: PlanType, price: Double) {
        let price = planType == .unlimited ? resultModel.priceInformation.unlimitedPriceHour : resultModel.priceInformation.limitedPriceHour
        let pricePerMinute = price / 60
        let totalPrice = Double(minutes) * pricePerMinute
        if let currency = totalPrice.currency {
            textLabel.text = currency
        } else {
            textLabel.text = "No se obtuvo el monto"
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
