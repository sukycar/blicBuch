//
//  DialogViewController.swift
//  zippit
//
//  Created by Milos Mladenovic on 4/19/19.
//  Copyright © 2019 NXTLVL Technology LLC. All rights reserved.
//

import UIKit
import PopupDialog

private let kMaxTextViewHeight: CGFloat = 200.0

class DialogViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var leftTitleLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var rightButton: UIButton!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var textField: UITextField!
    
    // MARK: - Properties
    
    var titleText: String?
    var leftTitleText: String?
    var textFieldText: String?
    var placeHolder: String?
    var messageText: String?
    var rightButtonTitle: String?
    var leftButtonTitle: String?
    var closeButtonHandler: (() -> Void)?
    var rightButtonHandler: (() -> Void)?
    var leftButtonHandler: (() -> Void)?
    var showLeftButton = false {
        didSet {
            guard isViewLoaded else { return }
            leftButton.isHidden = !showLeftButton
        }
    }
    var showTextField = false {
        didSet {
            guard isViewLoaded else { return }
            textField.isHidden = !showTextField
        }
    }
    
    private var textViewContentSizeObserver: NSKeyValueObservation?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.leftButton.isHidden = !showLeftButton
        self.textField.isHidden = !showTextField
        self.separatorView.isHidden = true
        
        self.containerView.backgroundColor = .white
        self.containerView.layer.cornerRadius = 15
        self.containerView.layer.masksToBounds = false
        
        self.textField.placeholder = placeHolder
        self.textField.keyboardType = .default
        self.textField.layer.borderWidth = 1
        self.textField.layer.borderColor = UIColor.gray.cgColor
        self.textField.layer.cornerRadius = 8
        
        self.titleLabel.textColor = .white
        if let titleText = self.titleText {
            self.titleLabel.text = titleText
        } else {
            self.titleLabel.isHidden = true
        }
        self.leftButton.layer.cornerRadius = 16
        self.leftButton.layer.masksToBounds = true
        
        // Configure dialog with close button
        self.leftTitleLabel.textColor = .orange
        self.leftTitleLabel.font = UIFont(name: FontName.bold.value, size: 16)
        if let leftTitleText = leftTitleText {
            self.leftTitleLabel.text = leftTitleText
            self.separatorView.translatesAutoresizingMaskIntoConstraints = false
            self.separatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -20).isActive = true
            self.separatorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 20).isActive = true
            self.separatorView.isHidden = false
            self.separatorView.backgroundColor = .lightGray
            self.closeButton.isHidden = false
            self.textField.font = UIFont(name: FontName.bold.value, size: 14)
            self.rightButton.backgroundColor = .black
        } else {
            self.leftTitleLabel.isHidden = true
            self.closeButton.isHidden = true
        }
        
        self.textView.isEditable = false
        self.textView.backgroundColor = .clear
        self.textView.textColor = .black
        self.textView.text = messageText
        self.textView.textAlignment = .center
        self.textView.indicatorStyle = .white
        self.textViewContentSizeObserver
            = textView.observe(\.contentSize,
                               changeHandler: { [weak self] textView, _ in
                                guard let self = self else { return }
                                let height = textView.contentSize.height
                                self.textViewHeightConstraint.constant
                                    = height < kMaxTextViewHeight ? height : kMaxTextViewHeight
                                if height >= kMaxTextViewHeight {
                                    textView.flashScrollIndicators()
                                }
                               })
        
        self.rightButton.setTitle(rightButtonTitle, for: .normal)
        self.rightButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        self.leftButton.setTitle(leftButtonTitle, for: .normal)
        self.leftButton.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        self.textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        self.closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
    }
    
    deinit {
        textViewContentSizeObserver = nil
    }
    
    @objc private func rightButtonAction() {
        dismiss(animated: true, completion: rightButtonHandler)
    }
    
    @objc private func leftButtonAction() {
        dismiss(animated: true, completion: leftButtonHandler)
    }
    
    @objc private func closeButtonAction() {
        dismiss(animated: true, completion: closeButtonHandler)
    }
    
    @objc private func editingChanged(_ sender: UITextField) {
        textFieldText = sender.text
    }
}

extension UIViewController {
    
    @discardableResult
    func showAlert(title: String? = nil,
                   message: String?,
                   buttonTitle: String? = "OK",
                   handler: (() -> Void)? = nil) -> PopupDialog? {
        
        if let dialogView = UIStoryboard(name: "Alert", bundle: nil).instantiateInitialViewController()
            as? DialogViewController {
            dialogView.self.titleText = title
            dialogView.messageText = message
            dialogView.rightButtonTitle = buttonTitle
            dialogView.rightButtonHandler = handler
            dialogView.showLeftButton = false
            
            let popupDialog = PopupDialog(viewController: dialogView, tapGestureDismissal: false)
            
            let containerView = PopupDialogContainerView.appearance()
            containerView.backgroundColor = .clear
            containerView.shadowEnabled = false
            containerView.cornerRadius = Float(8)
            
            let overlayView = PopupDialogOverlayView.appearance()
            overlayView.blurEnabled = false
            overlayView.opacity = 0.7
            overlayView.color = .black
            
            present(popupDialog, animated: true, completion: nil)
            
            return popupDialog
        }
        return nil
    }
    
    @discardableResult
    func showAlert(alertMessage: AlertMessage,
                   buttonTitle: String? = "OK",
                   handler: (() -> Void)? = nil) -> PopupDialog? {
        
        if let dialogView = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(withIdentifier: "DialogViewController")
            as? DialogViewController {
//            dialogView.self.titleText = alertMessage.title
            dialogView.messageText = alertMessage.body
            dialogView.rightButtonTitle = buttonTitle
            dialogView.rightButtonHandler = handler
            dialogView.showLeftButton = false
            
            let popupDialog = PopupDialog(viewController: dialogView, tapGestureDismissal: false)
            
            let containerView = PopupDialogContainerView.appearance()
            containerView.backgroundColor = .clear
            containerView.shadowEnabled = false
            containerView.cornerRadius = Float(8)
            
            let overlayView = PopupDialogOverlayView.appearance()
            overlayView.blurEnabled = false
            overlayView.opacity = 0.7
            overlayView.color = .black
            
            present(popupDialog, animated: true, completion: nil)
            
            return popupDialog
        }
        return nil
    }
    
    @discardableResult
    func showAlert(title: String? = nil,
                   message: String?,
                   leftButtonTitle: String = "OK",
                   leftButtonHandler: (() -> Void)?,
                   rightButtonTitle: String,
                   rightButtonHandler: (() -> Void)?) -> PopupDialog? {
        
        if let dialogView = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(withIdentifier: "DialogViewController")
            as? DialogViewController {
            dialogView.self.titleText = title
            dialogView.messageText = message
            dialogView.rightButtonHandler = rightButtonHandler
            dialogView.leftButtonHandler = leftButtonHandler
            dialogView.rightButtonTitle = rightButtonTitle
            dialogView.leftButtonTitle = leftButtonTitle
            dialogView.showLeftButton = true
            
            let popupDialog = PopupDialog(viewController: dialogView, tapGestureDismissal: false)
            
            let containerView = PopupDialogContainerView.appearance()
            containerView.backgroundColor = .clear
            containerView.shadowEnabled = false
            containerView.cornerRadius = Float(8)
            
            let overlayView = PopupDialogOverlayView.appearance()
            overlayView.blurEnabled = false
            overlayView.opacity = 0.7
            overlayView.color = .black
            
            present(popupDialog, animated: true, completion: nil)
            
            return popupDialog
        }
        return nil
    }
    
    @discardableResult
    func showTextFieldAlert(title: String? = nil,
                            message: String?,
                            leftButtonTitle: String = "OK",
                            leftButtonHandler: ((String?) -> Void)?,
                            rightButtonTitle: String,
                            rightButtonHandler: (() -> Void)?,
                            placeholder: String?) -> PopupDialog? {
        
        if let dialogView = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(withIdentifier: "DialogViewController")
            as? DialogViewController {
            dialogView.self.titleText = title
            dialogView.messageText = message
            dialogView.leftButtonHandler = {
                leftButtonHandler?(dialogView.textFieldText)
            }
            dialogView.rightButtonHandler = rightButtonHandler
            dialogView.rightButtonTitle = rightButtonTitle
            dialogView.leftButtonTitle = leftButtonTitle
            dialogView.showLeftButton = true
            dialogView.showTextField = true
            dialogView.placeHolder = placeholder
            
            let popupDialog = PopupDialog(viewController: dialogView, tapGestureDismissal: false)
            
            let containerView = PopupDialogContainerView.appearance()
            containerView.backgroundColor = .clear
            containerView.shadowEnabled = false
            containerView.cornerRadius = Float(8)
            
            let overlayView = PopupDialogOverlayView.appearance()
            overlayView.blurEnabled = false
            overlayView.opacity = 0.7
            overlayView.color = .black
            
            present(popupDialog, animated: true, completion: nil)
            
            return popupDialog
        }
        return nil
    }
    
    @discardableResult
    func showLogoutAlert(title: String? = "Logout",
                         message: String? = "Are you sure you want to logout?",
                         leftButtonTitle: String = "Yes",
                         leftButtonHandler: (() -> Void)?,
                         rightButtonTitle: String = "No",
                         rightButtonHandler: (() -> Void)?,
                         closeButtonHandler: (() -> Void)?) -> PopupDialog? {
        
        if let dialogView = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(withIdentifier: "DialogViewController")
            as? DialogViewController {
            dialogView.leftTitleText = title
            dialogView.messageText = message
            dialogView.rightButtonHandler = rightButtonHandler
            dialogView.leftButtonHandler = leftButtonHandler
            dialogView.rightButtonTitle = rightButtonTitle
            dialogView.leftButtonTitle = leftButtonTitle
            dialogView.closeButtonHandler = closeButtonHandler
            dialogView.showLeftButton = true
            
            let popupDialog = PopupDialog(viewController: dialogView, tapGestureDismissal: false)
            
            let containerView = PopupDialogContainerView.appearance()
            containerView.backgroundColor = .clear
            containerView.shadowEnabled = false
            containerView.cornerRadius = Float(8)
            
            let overlayView = PopupDialogOverlayView.appearance()
            overlayView.blurEnabled = false
            overlayView.opacity = 0.7
            overlayView.color = .black
            
            present(popupDialog, animated: true, completion: nil)
            
            return popupDialog
        }
        return nil
    }
    
    @discardableResult
    func showDeleteItemAlert(title: String? = "Delete",
                             itemName: String,
                             message: String = "Are you sure you want to delete ",
                             leftButtonTitle: String = "Yes",
                             leftButtonHandler: (() -> Void)?,
                             rightButtonTitle: String = "No",
                             rightButtonHandler: (() -> Void)?,
                             closeButtonHandler: (() -> Void)?) -> PopupDialog? {
        
        if let dialogView = UIStoryboard(name: "Alert", bundle: nil).instantiateViewController(withIdentifier: "DialogViewController")
            as? DialogViewController {
            dialogView.leftTitleText = title
            dialogView.messageText = message + itemName + " from list?"
            dialogView.rightButtonHandler = rightButtonHandler
            dialogView.leftButtonHandler = leftButtonHandler
            dialogView.rightButtonTitle = rightButtonTitle
            dialogView.leftButtonTitle = leftButtonTitle
            dialogView.closeButtonHandler = closeButtonHandler
            dialogView.showLeftButton = true
            
            let popupDialog = PopupDialog(viewController: dialogView, tapGestureDismissal: false)
            
            let containerView = PopupDialogContainerView.appearance()
            containerView.backgroundColor = .clear
            containerView.shadowEnabled = false
            containerView.cornerRadius = Float(8)
            
            let overlayView = PopupDialogOverlayView.appearance()
            overlayView.blurEnabled = false
            overlayView.opacity = 0.7
            overlayView.color = .black
            
            present(popupDialog, animated: true, completion: nil)
            
            return popupDialog
        }
        return nil
    }
}

