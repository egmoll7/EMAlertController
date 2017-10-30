//
//  EMAlertTextField.swift
//  EMAlertController
//
//  Created by Eduardo Moll on 10/23/17.
//  Copyright © 2017 Eduardo Moll. All rights reserved.
//

import UIKit

internal protocol Separatable {
  func addSeparator(_ view: UIView)
}

internal extension Separatable {
  func addSeparator(_ view: UIView) {
    let separator = UIView()
    separator.translatesAutoresizingMaskIntoConstraints = false
    separator.backgroundColor = UIColor.emSeparatorColor.withAlphaComponent(0.4)
    
    view.addSubview(separator)
    
    separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    separator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    separator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    separator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
  }
}

open class EMAlertTextField: UITextField {
  
  // MARK: - Initializers
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  public init(placeholderText: String?, alertController: EMAlertController) {
    super.init(frame: .zero)
    placeholder = placeholderText
    delegate = alertController
    
    setUp()
  }
}

// MARK: - Setup Methods
extension EMAlertTextField: Separatable {
  
  fileprivate func setUp() {
    borderStyle = .none
    font = UIFont.systemFont(ofSize: 14)
    returnKeyType = .default
    textAlignment = .center
    
    addSeparator(self)
  }
}
