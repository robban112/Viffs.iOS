//
//  SecondViewController.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-15.
//  Copyright © 2018 Blipp. All rights reserved.
//
import UIKit
import CoreNFC

class SecondViewController: UIViewController, NFCNDEFReaderSessionDelegate {
  
  var nfcSession: NFCNDEFReaderSession?
  
  //MARK: Outlets
  @IBOutlet var carduid: UILabel!
  
  //MARK: Actions
  @IBAction func scanButton(_ sender: Any) {
    nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
    nfcSession?.begin()
  }
  
  func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    var result = ""
    for payload in messages[0].records {
      result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)! // 1
    }
    
    DispatchQueue.main.async {
      self.carduid.text = result
    }
  }
  
  func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    print("The session was invalidated: \(error.localizedDescription)")
  }
}
