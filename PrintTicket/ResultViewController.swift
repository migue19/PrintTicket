//
//  ResultViewController.swift
//  PrintTicket
//
//  Created by Miguel Mexicano Herrera on 02/08/23.
//

import UIKit
import NutUtils
class ResultViewController: UIViewController {
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    var amount: Double = 0.0
    var dateInformation: DateInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currency = amount.currency {
            textLabel.text = currency
        } else {
            textLabel.text = "No se obtuvo el monto"
        }
        if let dateInformation = dateInformation {
            daysLabel.text = "\(dateInformation.days)"
            hoursLabel.text = "\(dateInformation.hours)"
            minutesLabel.text = "\(dateInformation.minutes)"
            secondsLabel.text = "\(dateInformation.seconds)"
        }
    }
}
