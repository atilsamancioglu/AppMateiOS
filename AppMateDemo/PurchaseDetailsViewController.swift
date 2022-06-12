//
//  PurchaseDetailsViewController.swift
//  AppMateDemo
//
//  Created by Atil Samancioglu on 12.06.2022.
//

import UIKit
import appmate

class PurchaseDetailsViewController: UIViewController {
    var chosenProduct : PurchaseInfo?

    @IBOutlet weak var purchaseDescLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(chosenProduct)
    }
    
    @IBAction func consumeButtonClicked(_ sender: Any) {
        
        
        PurchaseClient.shared.consumePurchaseWithPurchaseToken(chosenProduct!.purchaseToken) { response, error in
            if let response = response, response.result!.success {
                self.dismiss(animated: true)
            } else {
                print(error)
            }
        }
    }
    

}
