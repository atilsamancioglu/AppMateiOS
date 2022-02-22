//
//  ViewController.swift
//  AppMateDemo
//
//  Created by Atil Samancioglu on 11.02.2022.
//

import UIKit
import appmate

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var myProducts = [Product]()
    var selectedProduct : Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        
        PurchaseClient.shared.getProducts { products, error in
            if let products = products {
                self.myProducts = products
                print(products)
            } else {
                print(error)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myProducts.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.chosenProduct = selectedProduct
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = myProducts[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        let currentProduct = myProducts[indexPath.row]
        let currentProductName = currentProduct.productLocales?.first?.productName
        let currentProductPrice = currentProduct.appleActivePriceDetail?.price
        content.text = currentProductName
        content.secondaryText = currentProductPrice

        cell.contentConfiguration = content
        
        
        return cell
    }


}

