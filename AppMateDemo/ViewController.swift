//
//  ViewController.swift
//  AppMateDemo
//
//  Created by Atil Samancioglu on 11.02.2022.
//

import UIKit
import appmate
import Combine

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var purchasedProductLabel: UILabel!
    var myProductsFromStore = [Product]()
    var selectedProductToBePurchased : Product?
    
    var currentPurchased : PurchaseInfo?
    var myViewModel = MyViewModel()
    var cancellableBag = Set<AnyCancellable>()

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        myViewModel.getPurchasesAndDisplay()

      
        
        //get products from store
        PurchaseClient.shared.getProducts { products, error in
            if let products = products {
               self.myProductsFromStore = products
                print(products)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    self.tableView.reloadData()
                })
            } else {
                print(error?.localizedDescription as Any)
            }
        }
        
        //get purchased products and display
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear executed")
        
        myViewModel.getPurchasesAndDisplay()
        myViewModel.$purchasedProduct.sink { purchasedProduct in
            self.purchasedProductLabel.text = purchasedProduct
        }.store(in: &cancellableBag)
        
        myViewModel.$purcasedInfo.sink { purchaseInfo in
            self.currentPurchased = purchaseInfo
        }.store(in: &cancellableBag)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myProductsFromStore.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.chosenProduct = selectedProductToBePurchased
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProductToBePurchased = myProductsFromStore[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        let currentProduct = myProductsFromStore[indexPath.row]
        let currentProductName = currentProduct.productLocales?.first?.productName
        let currentProductPrice = currentProduct.appleActivePriceDetail?.price
        content.text = currentProductName
        content.secondaryText = currentProductPrice
        cell.contentConfiguration = content
        
        return cell
    }

    @IBAction func consumeButtonClicked(_ sender: Any) {
        if currentPurchased != nil {
            
            PurchaseClient.shared.consumePurchaseWithPurchaseToken(currentPurchased!.purchaseToken) { response, error in
                if let response = response, response.result!.success {
                    DispatchQueue.main.async {
                        self.purchasedProductLabel.text = "Ürün Başarıyla Kullanıldı"

                    }
                } else {
                    print(error)
                }
            }
        }
    }
   
    
    
}


class MyViewModel : ObservableObject {
    @Published var purchasedProduct : String = ""
    @Published var purcasedInfo : PurchaseInfo?
    
    private var purchaseList = [PurchaseInfo]()
    private var productList = [Product]()

    
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
    
    func getPurchasesAndDisplay()  {
    
        print("getpurchasesanddisplay executed")
            self.getPurchases { purchases in
                self.purcasedInfo = purchases.first
            //self.purchasedProductLabel.text = self.currentPurchased?.description
            self.getProducts(purchases: purchases) { products in
                print("products completion: \(products)")
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                    self.purchasedProduct = products.first?.productLocales?.first?.productName ?? ""
                })
            }
        }
        
    }
    
}
