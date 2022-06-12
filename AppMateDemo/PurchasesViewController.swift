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
    
    let purchases = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        let currentProduct = purchases[indexPath.row]
        let currentProductName = currentProduct.productLocales?.first?.productName
        let currentProductPrice = currentProduct.appleActivePriceDetail?.price
        content.text = currentProductName
        content.secondaryText = currentProductPrice

        cell.contentConfiguration = content
        
        return cell
    }
    

}
