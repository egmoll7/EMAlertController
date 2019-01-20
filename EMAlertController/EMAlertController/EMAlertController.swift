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
  static let padding: CGFloat = 15.0
  static let buttonHeight: CGFloat = 50.0
  static let iconHeight: CGFloat = 100.0
  static let textFieldHeight: CGFloat = 30.0
  
  static func width(from size: CGSize) -> CGFloat {
    return (size.width <= 414) ? size.width - 60 : 280
  }
}

open class EMAlertController: UIViewController {
  
  // MARK: - Properties
  internal var alertViewHeight: NSLayoutConstraint?
  internal var alertViewWidth: NSLayoutConstraint?
  internal var messageTextViewHeightConstraint: NSLayoutConstraint?
  internal var buttonStackViewHeightConstraint: NSLayoutConstraint?
  internal var buttonStackViewWidthConstraint: NSLayoutConstraint?
  internal var scrollViewHeightConstraint: NSLayoutConstraint?
  internal var imageViewHeight: CGFloat = Dimension.iconHeight
  internal var titleLabelHeight: CGFloat = 20
  internal var messageLabelHeight: CGFloat = 20
  internal var iconHeightConstraint: NSLayoutConstraint?
  internal var heighAnchor: NSLayoutConstraint?
  internal var isLaunch = true
  public var textFields: [UITextField] = []
  
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
    alertView.backgroundColor = .emAlertViewColor
    alertView.layer.cornerRadius = 5
    alertView.layer.shadowColor = UIColor.black.cgColor
    alertView.layer.shadowOpacity = 0.2
    alertView.layer.shadowOffset = CGSize(width: 0, height: 0)
    alertView.layer.shadowRadius = 5
    alertView.clipsToBounds = false
    alertView.layer.masksToBounds = false
    
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
      
      guard let _ = newValue, let constraint = messageTextViewHeightConstraint else { return }
      
      messageLabelHeight = 20.0
      messageTextView.removeConstraint(constraint)
      messageTextViewHeightConstraint = messageTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: messageLabelHeight)
      messageTextViewHeightConstraint!.isActive = true
    }
  }
  
  /// Returns the first textField
  public var firstTextField: UITextField? {
    get {
      guard let textField = self.textFields.first else { return nil }
      return textField
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
    
    public var cancelable: Bool = false {
        didSet {
            if (cancelable) {
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapBehind(_:)))
                backgroundView.addGestureRecognizer(tap)
            }
        }
    }
  
  /// A Boolean value indicating whether the message text is selectable
  public var isMessageSelectable: Bool = false {
    willSet {
      messageTextView.isSelectable = newValue
    }
  }
  
  /// Defines the types of information that can be detected in the message text
  public var dataDetectorTypes: UIDataDetectorTypes? {
    willSet {
      guard let newValue = newValue else { return }
      messageTextView.dataDetectorTypes = newValue
    }
  }
  
  // MARK: - Initializers
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  /// Creates a EMAlertController object with the specified icon, title and message
  public init(icon: UIImage?, title: String?, message: String?) {
    super.init(nibName: nil, bundle: nil)
    
    guard (icon != nil || title != nil || message != nil) else {
      fatalError("EMAlertController must have an icon, a title, or a message to display")
    }
    
    (icon != nil) ? (iconImage = icon) : (imageViewHeight = 0.0)
    (title != nil) ? (titleLabelHeight = 20) : (titleLabelHeight = 0.0)
    (message != nil) ? (messageLabelHeight = 20) : (messageLabelHeight = 0.0)
    
    titleText = title
    messageText = message
    messageTextView.isSelectable = isMessageSelectable 
    
    setUp()
  }
  
  /// Creates a EMAlertController object with the specified title and message
  public convenience init (title: String?, message: String?) {
    self.init(icon: nil, title: title, message: message)
  }
  
  open override func viewWillAppear(_ animated: Bool) {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  override open func viewDidLayoutSubviews() {
    if alertView.frame.height >= UIScreen.main.bounds.height - 80 {
      messageTextView.isScrollEnabled = true
    }
    
    // This is being called when typing
    if (isLaunch) {
      UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
        let transform = CGAffineTransform(translationX: 0, y: -100)
        self.alertView.transform = transform
        self.isLaunch = false
      }, completion: nil)
    }
  }
  
  override open func viewWillDisappear(_ animated: Bool) {
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
      let transform = CGAffineTransform(translationX: 0, y: 50)
      self.alertView.transform = transform
    }, completion: nil)
  }
  
  open override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    
    if size.height < size.width {
      alertViewHeight?.constant = size.height - 40
      iconHeightConstraint?.constant = 0
    } else {
      alertViewHeight?.constant = size.height - 80
      iconHeightConstraint?.constant = imageViewHeight
    }
    
    alertViewWidth?.constant = Dimension.width(from: size)
    
    UIView.animate(withDuration: 0.3) {
      self.alertView.updateConstraints()
    }
  }
}

// MARK: - Setup Methods
extension EMAlertController {
  
  internal func setUp() {
    self.modalPresentationStyle = .custom
    self.modalTransitionStyle = .crossDissolve
    
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
    alertViewWidth = alertView.widthAnchor.constraint(equalToConstant: Dimension.width(from: view.bounds.size))
    alertViewWidth?.isActive = true
    alertViewHeight = alertView.heightAnchor.constraint(lessThanOrEqualToConstant: view.bounds.height - 80)
    alertViewHeight?.isActive = true
    
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
    titleLabel.sizeToFit()
    
    // messageLabel Constraints
    messageTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
    messageTextView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: Dimension.padding).isActive = true
    messageTextView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -Dimension.padding).isActive = true
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

// MARK: - Internal Methods
extension EMAlertController {
  @objc internal func dismissFromTap() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc internal func keyboardWillShow() {
    UIView.animate(withDuration: 0.3) {
      let transform = CGAffineTransform(translationX: 0, y: -200)
      self.alertView.transform = transform
    }
  }
  
  @objc internal func keyboardWillHide() {
    UIView.animate(withDuration: 0.3) {
      let transform = CGAffineTransform(translationX: 0, y: -100)
      self.alertView.transform = transform
    }
  }
}

// MARK: - Action Methods
extension EMAlertController {
  open func addAction(_ action: EMAlertAction) {
    buttonStackView.addArrangedSubview(action)
    
    if buttonStackView.arrangedSubviews.count > 2 || textFields.count > 0 {
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
    
    @objc func handleTapBehind(_ sender: Any?) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TextField Methods
extension EMAlertController {
  internal func addTextField(_ textfield: UITextField) {
    textFields.append(textfield)
    buttonStackView.addArrangedSubview(textfield)
    buttonStackViewHeightConstraint?.constant = Dimension.buttonHeight * CGFloat(buttonStackView.arrangedSubviews.count)
    buttonStackView.axis = .vertical
  }
  
  ///
  open func addTextField(_ configuration: (_ textField: UITextField?) -> ()) {
    let textField = EMAlertTextField()
    textField.delegate = self
    configuration(textField)
    addTextField(textField)
  }
}

// MARK: - Textfield Delegates
extension EMAlertController: UITextFieldDelegate {
  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
