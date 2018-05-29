//
//  ReceiptViewController.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-15.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ReceiptViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var receipts = [Receipt]()
    var handle: AuthStateDidChangeListenerHandle?
    var ref: DatabaseReference!
    var selectedReceipt: Receipt?
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedReceipt = receipts[indexPath.row]
        performSegue(withIdentifier: "receiptDetail", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ReceiptDetailViewController {
            dest.receipt = selectedReceipt
        }
    }
    

    @IBOutlet var receiptTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiptTableView.dataSource = self
        receiptTableView.delegate = self
        ref = Database.database().reference()
        //mockData()
    }
    
    func mockData() {
        let receipt1 = Receipt(name: "Hemköp", total: "399", url:"")
        let receipt2 = Receipt(name: "Pressbyrån", total: "249", url:"")
        let receipt3 = Receipt(name: "Elgiganten", total: "59", url:"")
        receipts.append(receipt1)
        receipts.append(receipt2)
        receipts.append(receipt3)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                let receiptsRef = self.ref.child("users/\(user.uid)/receipts")
                receiptsRef.observe(DataEventType.value, with: { (snapshot) in
                    if let receipts = snapshot.value as? [AnyObject] {
                        self.mapReceipts(objs: receipts)
                        self.receiptTableView.reloadData()
                    } else {
                        print("Unable to parse receipts to [AnyObject]")
                    }
                })
            }
        }
    }
    
    func mapReceipts(objs: [AnyObject]) {
        receipts.removeAll()
        for obj in objs {
            if let dic = obj as? [String:AnyObject] {
                let receipt = Receipt(name: dic["name"] as! String, total: dic["total"] as! String, url: dic["url"] as! String)
                receipts.append(receipt)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

