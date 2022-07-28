//
//  PurchasesViewController.swift
//  AppMateDemo
//
//  Created by Atil Samancioglu on 12.06.2022.
//

import UIKit
import appmate

class PurchasesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UIAdaptivePresentationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var purchaseList = [PurchaseInfo]()
    var selectedProduct : PurchaseInfo?
    var productList = [Product]()
    var purchaseDetailsVC : PurchaseDetailsViewController? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        
        purchaseDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "purchaseDetailsVC") as? PurchaseDetailsViewController
   

    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
 
             getPurchasesAndDisplay()
        //standardDisplay()

        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
    
             getPurchasesAndDisplay()
        //standardDisplay()
        
        
    }
    
    private func standardDisplay() {
        PurchaseClient.shared.getCurrentPurchases { purchases, error in
            if let purchases = purchases {
                self.purchaseList = purchases
                let productIds = purchases.map {$0.productId}
                PurchaseClient.shared.getProductsWithIdList(productIds) { products, error in
                    if let products = products {
                        self.productList = products
                        self.tableView.reloadData()
                    }
                    
                }
            }
            
            
        }
    }
    
    private func getPurchases(completion: @escaping([PurchaseInfo]) -> Void ) {
        purchaseList.removeAll(keepingCapacity: false)

        PurchaseClient.shared.getCurrentPurchases { purchases, error in
            print("first async executed")
            if let purchases = purchases {
                self.purchaseList = purchases
                completion(purchases)
            }
           
        }
    }
    
    private func getProducts(purchases:[PurchaseInfo], completion: @escaping([Product]) -> Void) {
        productList.removeAll(keepingCapacity: false)

        let productIds = purchases.map {$0.productId}

        PurchaseClient.shared.getProductsWithIdList(productIds) { products, error in
            print("second async executed")

                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    if let products = products {
                        self.productList = products
                        completion(products)

                    }
                }
        }
     
    }
    
    private func getPurchasesAndDisplay()  {
        print("getpurchasesanddisplay executed")
        getPurchases { purchases in
            self.getProducts(purchases: purchases) { products in
                print("products completion: \(products)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if productList.isEmpty {
            content.text = "No products :( Maybe you can purchase something?"
        } else {
            let currentProduct = productList[indexPath.row]
            let currentProductName = currentProduct.productLocales?.first?.productName
            let currentProductPrice = currentProduct.appleActivePriceDetail?.price
            content.text = currentProductName
            content.secondaryText = currentProductPrice
        }


        cell.contentConfiguration = content
        
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = purchaseList[indexPath.row]
        purchaseDetailsVC?.chosenProduct = selectedProduct
        purchaseDetailsVC?.presentationController?.delegate = self
        self.present(purchaseDetailsVC!, animated: true,completion: nil)
        
    }
    

}
