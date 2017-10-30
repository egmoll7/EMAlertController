//
//  ViewController.swift
//  EMAlertController
//
//  Created by Eduardo Moll on 10/13/17.
//  Copyright © 2017 Eduardo Moll. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension ViewController {
  
  @IBAction func showAlert(sender: UIButton) {
    
    let alert = EMAlertController(icon: UIImage(named: "icon"), title: "EMAlertView Title", message: "This is a simple message for the EMAlertView")
    
    let textfield = EMAlertTextField(placeholderText: "Username", alertController: alert)
    let textfield2 = EMAlertTextField(placeholderText: "Password", alertController: alert)
    textfield2.isSecureTextEntry = true
    
    alert.addTextField(textfield)
    alert.addTextField(textfield2)
    
    let action1 = EMAlertAction(title: "CANCEL", style: .cancel)
    let action2 = EMAlertAction(title: "CONFIRM", style: .normal) {
      // Perform action
    }
    
    alert.addAction(action1)
    alert.addAction(action2)
    
    present(alert, animated: true, completion: nil)
  }
}
