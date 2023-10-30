//
//  ResultViewController.swift
//  PrintTicket
//
//  Created by Miguel Mexicano Herrera on 02/08/23.
//

import UIKit
import NutUtils
class ResultViewController: UIViewController {
    @IBOutlet weak var planTypeLabel: UILabel!
    let tolerance: Int = 10
    @IBOutlet weak var completeDayLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    var resultModel: ResultModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        validateInformation()
    }
    func titleInformation(resultModel: ResultModel) {
        let planType = resultModel.planType
        planTypeLabel.text = planType == .limited ? "LIMITADO" : "ILIMITADO"
    }
    func dateInformation(resultModel: ResultModel) {
        let dateInformation = resultModel.dateInformation
        daysLabel.text = "\(dateInformation.days)"
        hoursLabel.text = "\(dateInformation.hours)"
        minutesLabel.text = "\(dateInformation.minutes)"
        secondsLabel.text = "\(dateInformation.seconds)"
    }
    func validateInformation() {
        guard let resultModel = resultModel else {
            return
        }
        titleInformation(resultModel: resultModel)
        dateInformation(resultModel: resultModel)
        let planType = resultModel.planType
        let priceInformation = resultModel.priceInformation
        let dateInformation = resultModel.dateInformation
        let minutes = dateInformation.discountTime.minute ?? 0
        if dateInformation.days >= 1 {
            completeDayLabel.isHidden = true
            alertWithDelay(message: "No puedes exceder mas de un Día")
            return
        }
        /// Precio por dia
        if dateInformation.hours >= 4 {
            completeDayLabel.isHidden = false
            let price = priceInformation.priceDay
            if let currency = price.currency {
                textLabel.text = currency
            } else {
                textLabel.text = "No se obtuvo el monto"
            }
        } else {
            completeDayLabel.isHidden = true
            if minutes > tolerance {
                /// Calcular el precio en base a los minutos transcurridos
                if minutes > 60 {
                    getAmount(minutes: minutes, planType: planType, price: priceInformation.priceHour)
                } else {
                    priceForType(type: .hour, priceInformation: priceInformation)
                }
            } else {
                priceForType(type: .zero, priceInformation: priceInformation)
            }
        }
    }
    func priceForType(type: PriceType,priceInformation: PriceInformation) {
        var price: Double = 0
        switch type {
        case .day:
            price = priceInformation.priceDay
        case .hour:
            price = priceInformation.priceHour
        case .zero:
            price = 0
        }
        textLabel.text = price.currency ?? ""
    }
    func getAmount(minutes: Int, planType: PlanType, price: Double) {
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
enum PriceType {
    case day
    case hour
    case zero
}
