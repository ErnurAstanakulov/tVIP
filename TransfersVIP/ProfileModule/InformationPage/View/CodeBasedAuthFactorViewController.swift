//
//  CodeBasedAuthFactorViewController.swift
//  TransfersVIP
//
//  Created by psuser on 10/15/19.
//  Copyright © 2019 psuser. All rights reserved.
//

import UIKit

class CodeBasedAuthFactorViewController: UIViewController, ExtendedUIViewController {
    
    var containerView = UIView()
    var containerViewCenterYAnchorConstraint: NSLayoutConstraint?
    
    var performOnClose: (() -> Void)?
    
    
    override func loadView() {
        super.loadView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(containerView)
        
        setupConstraints()
        stylize()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardEvents()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardEvents()
    }
    
    
    public func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        containerViewCenterYAnchorConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        containerViewCenterYAnchorConstraint?.isActive = true
    }
    
    func setContainerSubview(_ subview: UIView) {
        containerView.endEditing(true)
        containerView.subviews.first?.removeFromSuperview()
        containerView.addSubview(subview)
        
        containerView.topAnchor.constraint(equalTo: subview.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: subview.bottomAnchor).isActive = true
        subview.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        subview.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
    }
    
    func stylize() {
        view.backgroundColor = AppColor.dark.uiColor.withAlphaComponent(0.75)
    }
    
    // MARK: Keyboard related events observation
    
    /// Start observing keyboard events
    private func addKeyboardEvents() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    /// Stop observing keyboard events
    private func removeKeyboardEvents() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    /// Perform when keyboard will show
    ///
    /// - Parameter notification: notification container
    @objc private func keyboardWillShow(notification: Notification) {
        guard let infoNSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardFrame = infoNSValue.cgRectValue
        let containerViewFrame = containerView.frame
        let coveredSpace = containerViewFrame.maxY + 8 - keyboardFrame.origin.y
        if coveredSpace > 0 {
            containerViewCenterYAnchorConstraint?.constant -= coveredSpace
            UIView.animate(withDuration: 0.5, animations: view.layoutIfNeeded)
        }
    }
    
    /// Perform when keyboard will hide
    ///
    /// - Parameter notification: notification container
    @objc private func keyboardWillHide(notification: Notification) {
        hideCenterConstant()
        UIView.animate(withDuration: 0.5, animations: view.layoutIfNeeded)
    }
    
    public func hideCenterConstant() {
        containerViewCenterYAnchorConstraint?.constant = 0
    }
    
    /// Perform when app will switch to the background
    ///
    /// - Parameter notification: notification container
    @objc private func applicationWillResignActive(notification: Notification) {
        view.endEditing(true)
    }
    
    @objc public func dismissViewController() {
        performOnClose?()
        dismiss(animated: true)
    }
}

extension CodeBasedAuthFactorViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let gestureRecognizerView = gestureRecognizer.view,
            let touchView = touch.view,
            gestureRecognizerView == view,
            touchView.isDescendant(of: containerView) {
            return false
        }
        
        return true
    }
}

