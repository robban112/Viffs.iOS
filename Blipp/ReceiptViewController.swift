//
//  ReceiptViewController.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-15.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import Firebase

class ReceiptViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var receipts = [Receipt]()
    var handle: AuthStateDidChangeListenerHandle?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receipts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ReceiptTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ReceiptTableViewCell else {
            fatalError("The dequeued cell is not an instance of ReceiptTableViewCell.")
        }
        if indexPath.row > receipts.count {
            return cell
        }
        let receipt: Receipt = receipts[indexPath.row]
        cell.receiptName.text = receipt.receiptName
        cell.receiptTotal.text = receipt.receiptTotal
        return cell
    }
    

    @IBOutlet var receiptTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiptTableView.dataSource = self
        receiptTableView.delegate = self
        let receipt1 = Receipt(name: "Hemköp", total: "399")
        let receipt2 = Receipt(name: "Pressbyrån", total: "249")
        let receipt3 = Receipt(name: "Elgiganten", total: "59")
        receipts.append(receipt1)
        receipts.append(receipt2)
        receipts.append(receipt3)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print(user.email)
                print("An user has logged in! - From ReceiptViewController")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

