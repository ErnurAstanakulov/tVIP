//
//  KeyboardCoverProtocol.swift
//  DigitalBank
//
//  Created by Adilbek Mailanov on 7/4/19.
//  Copyright © 2019 iosDeveloper. All rights reserved.
//

import Foundation
import UIKit

// Protocol to protect view from being covered by keyboard
protocol KeyboardCoverProtocol where Self: UIViewController {
    
    /// Potential frame in `scrollableView` that can be covered by keyboard
    var targetFrame: CGRect? { get }
    
    /// View to scroll
    var scrollableView: UIScrollView { get }
    
    /// `scrollableView.contentInset.bottom`
    var originalContentBottomInset: CGFloat { get }
    
    /// `scrollableView.scrollIndicatorInsets.bottom`
    var originalScrollIndicatorBottomInset: CGFloat { get }
    
    /// Start observing keyboard events
    func set(keyboardObservers: inout [Any])
    
    /// Stop observing keyboard events
    func remove(keyboardObservers: inout [Any])
}

extension KeyboardCoverProtocol {
    
    var originalContentBottomInset: CGFloat { return 0 }
    
    var originalScrollIndicatorBottomInset: CGFloat { return 0 }
    
    func set(keyboardObservers: inout [Any]) {
        let keyboardWillShowNotificationObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil,
            using: keyboardWillShow
        )
        
        let keyboardWillHideNotificationObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil,
            using: keyboardWillHide
        )
        
        keyboardObservers = [
            keyboardWillShowNotificationObserver,
            keyboardWillHideNotificationObserver
        ]
    }
    
    func remove(keyboardObservers: inout [Any]) {
        while !keyboardObservers.isEmpty {
            keyboardObservers.popLast().map(NotificationCenter.default.removeObserver)
        }
    }
    
    func reloadTableViewWithoutAnimation() {
        guard let tableView = scrollableView as? UITableView else {
            fatalError("Couldn't cast scrollableView to UITableView")
        }
        
        let contentOffset = scrollableView.contentOffset
        
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        
        tableView.layoutIfNeeded()
        tableView.contentOffset = contentOffset
    }
    
    private func keyboardWillShow(_ notification: Notification) {
        guard let targetFrame = targetFrame,
            let userInfo = notification.userInfo,
            let beginInfoValue = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue,
            let endInfoValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            beginInfoValue.cgRectValue.maxY != endInfoValue.cgRectValue.maxY else {
                return
        }
        
        let keyboardFrame = endInfoValue.cgRectValue
        let coveredSpace = targetFrame.maxY - keyboardFrame.origin.y
        
        if coveredSpace > 0 {
            var contentOffset = scrollableView.contentOffset
            contentOffset.y += coveredSpace
            scrollableView.setContentOffset(contentOffset, animated: true)
        }
        
        scrollableView.contentSize.height += (keyboardFrame.height - originalContentBottomInset)
        if #available(iOS 11.0, *),
            let navigationController = navigationController,
            navigationController.navigationBar.prefersLargeTitles {
            scrollableView.scrollIndicatorInsets.bottom = keyboardFrame.height - 49
        } else {
            scrollableView.scrollIndicatorInsets.bottom = keyboardFrame.height
        }
    }
    
    private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let infoValue = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
                return
        }
        
        let keyboardFrame = infoValue.cgRectValue
        scrollableView.contentSize.height -= (keyboardFrame.height - originalContentBottomInset)
        scrollableView.scrollIndicatorInsets.bottom = originalScrollIndicatorBottomInset
    }
}
