//
//  ResultViewController.swift
//  PrintTicket
//
//  Created by Miguel Mexicano Herrera on 02/08/23.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var textLabel: UILabel!
    var amount: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currency = amount.currency {
            textLabel.text = currency
        } else {
            textLabel.text = "No se obtuvo el monto"
        }
    }
}
