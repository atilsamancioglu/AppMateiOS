//
//  PurchasesViewController.swift
//  AppMateDemo
//
//  Created by Atil Samancioglu on 12.06.2022.
//

import UIKit
import appmate

class PurchasesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var purchaseList = [PurchaseInfo]()
    var selectedProduct : PurchaseInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        
        PurchaseClient.shared.getCurrentPurchases { purchases, error in
            if let purchases = purchases {
                self.purchaseList = purchases
                self.tableView.reloadData()
                print(purchases)
            } else {
                print(error)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        let currentProduct = purchaseList[indexPath.row]
        let currentProductName = currentProduct.description
        let currentProductPrice = currentProduct.price
        content.text = currentProductName
        content.secondaryText = currentProductPrice

        cell.contentConfiguration = content
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPurchaseDetailsVC" {
            let destinationVC = segue.destination as! PurchaseDetailsViewController
            destinationVC.chosenProduct = selectedProduct
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = purchaseList[indexPath.row]
        self.performSegue(withIdentifier: "toPurchaseDetailsVC", sender: nil)
    }
    

}
