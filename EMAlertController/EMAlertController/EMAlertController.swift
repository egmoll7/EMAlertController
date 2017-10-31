//
//  EMAlertController.swift
//  EMAlertController
//
//  Created by Eduardo Moll on 10/13/17.
//  Copyright © 2017 Eduardo Moll. All rights reserved.
//

import UIKit

// MARK: - EMAlerView Dimensions
enum Dimension {
  static var width: CGFloat {
      return (UIScreen.main.bounds.width <= 414.0) ? (UIScreen.main.bounds.width - 60) : 280
  }
  static let padding: CGFloat = 15.0
  static let buttonHeight: CGFloat = 50.0
  static let iconHeight: CGFloat = 100.0
}

open class EMAlertController: UIViewController {
  
  // MARK: - Properties
  internal var alertViewHeight: NSLayoutConstraint?
  internal var buttonStackViewHeightConstraint: NSLayoutConstraint?
  internal var buttonStackViewWidthConstraint: NSLayoutConstraint?
  internal var scrollViewHeightConstraint: NSLayoutConstraint?
  internal var imageViewHeight: CGFloat = Dimension.iconHeight
  internal var messageLabelHeight: CGFloat = 20
  internal var iconHeightConstraint: NSLayoutConstraint?
  
  internal lazy var backgroundView: UIView = {
    let bgView = UIView()
    bgView.translatesAutoresizingMaskIntoConstraints = false
    bgView.backgroundColor = .darkGray
    bgView.alpha = 0.3
    
    return bgView
  }()
  
  internal var alertView: UIView = {
    let alertView = UIView()
    alertView.translatesAutoresizingMaskIntoConstraints = false
    alertView.backgroundColor = UIColor.emAlertviewColor
    alertView.layer.cornerRadius = 5
    alertView.layer.shadowColor = UIColor.black.cgColor
    alertView.layer.shadowOpacity = 0.2
    alertView.layer.shadowOffset = CGSize(width: 0, height: 0)
    alertView.layer.shadowRadius = 5
    alertView.clipsToBounds = false
    
    return alertView
  }()
  
  internal var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    
    return imageView
  }()
  
  internal var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 17)
    label.textAlignment = .center
    label.textColor = .black
    label.numberOfLines = 2
    
    return label
  }()
  
  internal var messageTextView: UITextView = {
    let textview = UITextView()
    textview.translatesAutoresizingMaskIntoConstraints = false
    textview.font = UIFont.systemFont(ofSize: 14)
    textview.textAlignment = .center
    textview.isEditable = false
    textview.showsHorizontalScrollIndicator = false
    textview.textColor = UIColor.black
    textview.backgroundColor = UIColor.clear
    textview.isScrollEnabled = false
    textview.isSelectable = false
    textview.bounces = false
    
    return textview
  }()
  
  internal let buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.axis = .horizontal
    
    return stackView
  }()
  
  public var cornerRadius: CGFloat? {
    willSet {
      alertView.layer.cornerRadius = newValue!
    }
  }
  
  public var iconImage: UIImage? {
    get {
      return imageView.image
    }
    set {
      imageView.image = newValue
      guard let image = newValue else {
        imageViewHeight = 0
        iconHeightConstraint?.constant = imageViewHeight
        return
      }
      (image.size.height > CGFloat(0.0)) ? (imageViewHeight = Dimension.iconHeight) : (imageViewHeight = 0)
      iconHeightConstraint?.constant = imageViewHeight
    }
  }
  
  public var titleText: String? {
    get {
      return titleLabel.text
    }
    set {
       titleLabel.text = newValue
    }
  }
  
  public var messageText: String? {
    get {
      return messageTextView.text
    }
    set {
      messageTextView.text = newValue
    }
  }
  
  public var titleColor: UIColor? {
    willSet {
      titleLabel.textColor = newValue
    }
  }
  
  public var messageColor: UIColor? {
    willSet {
      messageTextView.textColor = newValue
    }
  }
  
  /// Alert background color
  public var backgroundColor: UIColor? {
    willSet {
      alertView.backgroundColor = newValue
    }
  }
  
  public var backgroundViewColor: UIColor? {
    willSet {
      backgroundView.backgroundColor = newValue
    }
  }
  
  public var backgroundViewAlpha: CGFloat? {
    willSet {
      backgroundView.alpha = newValue!
    }
  }
  
  /// Spacing between actions when presenting two actions in horizontal
  public var buttonSpacing: CGFloat = 15 {
    willSet {
      buttonStackView.spacing = newValue
    }
  }
  
  // MARK: - Initializers
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  /// Creates a EMAlertController object with the specified icon, title and message
  public init(icon: UIImage?, title: String, message: String?) {
    super.init(nibName: nil, bundle: nil)
    
    titleText = title
    messageText = message
    
    (icon != nil) ? (iconImage = icon) : (imageViewHeight = 0.0)
    (message != nil) ? (messageLabelHeight = 20) : (messageLabelHeight = 0.0)
    
    setUp()
  }
  
  /// Creates a EMAlertController object with the specified title and message
  public convenience init (title: String, message: String?) {
    self.init(icon: nil, title: title, message: message)
  }

  override open func viewDidLayoutSubviews() {
    if alertView.frame.height >= UIScreen.main.bounds.height - 80 {
      messageTextView.isScrollEnabled = true
    }

    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
      let transform = CGAffineTransform(translationX: 0, y: -100)
      self.alertView.transform = transform
    }, completion: nil)
  }
  
  override open func viewWillDisappear(_ animated: Bool) {
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
      let transform = CGAffineTransform(translationX: 0, y: 50)
      self.alertView.transform = transform
    }, completion: nil)
  }
  
  open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    alertViewHeight?.constant = size.height - 80
    alertView.layoutIfNeeded()
  }
}

// MARK: - Setup Methods
extension EMAlertController {
  
  internal func setUp() {
    self.modalPresentationStyle = .custom
    self.modalTransitionStyle = .crossDissolve
    
    // TODO: Add touch handler to backgroundView

    addConstraits()
  }
  
  internal func addConstraits() {
    view.addSubview(alertView)
    view.insertSubview(backgroundView, at: 0)
    
    alertView.addSubview(imageView)
    alertView.addSubview(titleLabel)
    alertView.addSubview(messageTextView)
    alertView.addSubview(buttonStackView)
    
    // backgroundView Constraints
    backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    
    // alertView Constraints
    alertView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 100).isActive = true
    alertView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
    alertView.widthAnchor.constraint(equalToConstant: Dimension.width).isActive = true
    alertViewHeight = alertView.heightAnchor.constraint(lessThanOrEqualToConstant: view.bounds.height - 80)
    alertViewHeight!.isActive = true
    
    // imageView Constraints
    imageView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 5).isActive = true
    imageView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: Dimension.padding).isActive = true
    imageView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -Dimension.padding).isActive = true
    iconHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: imageViewHeight)
    iconHeightConstraint?.isActive = true
    
    // titleLabel Constraints
    titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: Dimension.padding).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -Dimension.padding).isActive = true
    titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
    titleLabel.sizeToFit()
    
    // messageLabel Constraints
    messageTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
    messageTextView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: Dimension.padding).isActive = true
    messageTextView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -Dimension.padding).isActive = true
    messageTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: messageLabelHeight).isActive = true
    messageTextView.sizeToFit()
  
    // actionStackView Constraints
    buttonStackView.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 8).isActive = true
    buttonStackView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 0).isActive = true
    buttonStackView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: 0).isActive = true
    buttonStackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 0).isActive = true
    buttonStackViewHeightConstraint = buttonStackView.heightAnchor.constraint(equalToConstant: (Dimension.buttonHeight * CGFloat(buttonStackView.arrangedSubviews.count)))
    buttonStackViewHeightConstraint!.isActive = true
  }
}

// MARK: - Action Methods
extension EMAlertController {
   open func addAction(action: EMAlertAction) {
    buttonStackView.addArrangedSubview(action)
    
    if buttonStackView.arrangedSubviews.count > 2 {
      buttonStackView.axis = .vertical
      buttonStackViewHeightConstraint?.constant = Dimension.buttonHeight * CGFloat(buttonStackView.arrangedSubviews.count)
      buttonStackView.spacing = 0
    } else {
      buttonStackViewHeightConstraint?.constant = Dimension.buttonHeight
      buttonStackView.axis = .horizontal
      buttonStackView.spacing = 15
    }
    
    action.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
  }
  
  @objc func buttonAction(sender: EMAlertAction) {
    dismiss(animated: true, completion: nil)
  }
}
