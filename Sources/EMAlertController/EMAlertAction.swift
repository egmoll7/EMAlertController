//
//  EMAlertAction.swift
//  EMAlertController
//
//  Created by Eduardo Moll on 10/14/17.
//  Copyright © 2017 Eduardo Moll. All rights reserved.
//

import UIKit

public enum EMAlertActionStyle: Int {
  case normal
  case cancel
}

/// An action that can be taken when the user taps a button in an EMAlertController
open class EMAlertAction: UIButton {
  
  // MARK: - Properties
  internal var action: (() -> Void)?
  
  public var title: String? {
    willSet {
      setTitle(newValue, for: .normal)
    }
  }
  
  public var titleColor: UIColor? {
    willSet {
      setTitleColor(newValue, for: .normal)
    }
  }
  
  public var titleFont: UIFont? {
    willSet {
      self.titleLabel?.font = newValue
    }
  }
  
  public var actionBackgroundColor: UIColor? {
    willSet {
      backgroundColor = newValue
    }
  }

  // MARK: - Initializers
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  public init(title: String, titleColor: UIColor) {
    super.init(frame: .zero)
    
    self.setTitle(title, for: .normal)
    self.setTitleColor(titleColor, for: .normal)
  }
  
  public convenience init(title: String, style: EMAlertActionStyle, action: (() -> Void)? = nil) {
    self.init(type: .system)
    
    self.action = action
    self.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
    
    switch style {
      case .normal:
        setTitle(title: title, forStyle: .normal)
      
      case .cancel:
        setTitle(title: title, forStyle: .cancel)
    }
  }
}

extension EMAlertAction: Separatable {
  
  fileprivate func setTitle(title: String, forStyle: EMAlertActionStyle) {
    self.setTitle(title, for: .normal)
    addSeparator(self)
    clipsToBounds = true

    switch forStyle {
    case .normal:
      setTitleColor(.emActionColor, for: .normal)
      titleFont = UIFont.boldSystemFont(ofSize: 16)
      
    case .cancel:
      setTitleColor(.emCancelColor, for: .normal)
      titleFont = UIFont.boldSystemFont(ofSize: 16)
    }
  }
  @objc func actionTapped(sender: EMAlertAction) {
    self.action?()
  }
}
