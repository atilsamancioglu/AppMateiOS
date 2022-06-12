//
//  DetailsViewController.swift
//  AppMateDemo
//
//  Created by Atil Samancioglu on 22.02.2022.
//

import UIKit
import appmate

class DetailsViewController: UIViewController {
    
    var chosenProduct : Product?
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productNameLabel.text = chosenProduct?.productLocales?.first?.productName
        productDescriptionLabel.text = chosenProduct?.productLocales?.first?.productDesc
    }

    @IBAction func buyClicked(_ sender: Any) {
        if let chosenProduct = chosenProduct {
            PurchaseClient.shared.makePurchase(with: chosenProduct) { purchaseResult, purchaseCode in
                if purchaseResult != nil {
                    print(purchaseResult?.purchaseCode)
                    print(purchaseResult?.description)
                    print(purchaseResult.debugDescription)
                    print(purchaseResult?.purchaseInfo)
                    self.dismiss(animated: true)
                } else {
                    //print(purchaseCode.description)
                }
            }
        }
       

    }
    
}
