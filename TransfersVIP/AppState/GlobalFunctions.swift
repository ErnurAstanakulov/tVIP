//
//  GlobalFunctions.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 3/16/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import Alamofire

func logOut() {
    // Adapter contains accessToken
    guard let adapter = sessionManager.adapter as? AppRequestAdapter, adapter.accessToken != nil else { return }
    adapter.closeSession()
    let controller: UIAlertController = UIAlertController(title: "Внимание", message: "Внимание, срок сессии истек. Войдите в приложение заново.", preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Принять", style: .default)
    controller.addAction(cancelAction)
    
    GlobalFunctions.topViewController()?.present(controller, animated: true) {
        // Forcing keyboard dismissal
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    appDelegate?.gotoAuthScreen()
}

func bindDatePicker(_ picker: UIDatePicker, to textField: UITextField, withAction action: Selector, view: UIView) {
    textField.inputView = picker
    picker.datePickerMode = .date
    picker.addTarget(view, action: action, for: UIControl.Event.valueChanged)
}

func fill(textField: UITextField, fromPicker picker: UIDatePicker) -> Date {
    let date = picker.date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateString = dateFormatter.string(from: date)
    textField.text = dateString
    
    return picker.date
}

func keyboardVisibility(notification: NSNotification, completion: (_ frame: CGRect) -> Void) {
    let info = notification.userInfo!
    let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    completion(keyboardFrame)
}

func getLoadingIndicator(forTableView tableView: UITableView) -> UIActivityIndicatorView {
    let spinner = UIActivityIndicatorView(style: .gray)
    spinner.startAnimating()
    spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 22)
    return spinner
}

//DESC: transform 2016-12-01 to 01.12.2016
func fromServerDate(_ stringDate: String) -> String? {
   return stringDate.date(format: Constants.DateFormats.shortQuery)?
                    .stringWith(format: Constants.DateFormats.shortDot)
}

//DESC: transform 01.12.2016b to 2016-12-01 
func toServerDate(_ stringDate: String) -> String? {
    return stringDate.date(format: Constants.DateFormats.shortDot)?
                     .stringWith(format: Constants.DateFormats.shortQuery)
}

struct GlobalFunctions {

    static func unicodeFromCurrency(_ currency: String) -> String?  {
        switch currency {
        case Constants.Сurrency.KZT: return "T"
        case Constants.Сurrency.USD: return "$"
        case Constants.Сurrency.EUR: return "€"
        case Constants.Сurrency.RUB: return "₽"
        case Constants.Сurrency.GBP: return "£"
        case Constants.Сurrency.CNY: return "¥"
        default: return nil
        }
    }
    
    static func currnecyFromUnicode(_ currency: String) -> String? {
        switch currency {
        case "T": return Constants.Сurrency.KZT
        case "$": return Constants.Сurrency.USD
        case "€": return Constants.Сurrency.EUR
        case "₽": return Constants.Сurrency.RUB
        case "£": return Constants.Сurrency.GBP
        case "¥": return Constants.Сurrency.CNY
        default: return nil
        }
    }
    
    
    
    static func topViewController(base: UIViewController? = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController) -> UIViewController? {
        if let navigation = base as? UINavigationController {
            return topViewController(base: navigation.visibleViewController)
        }
        
        if let tabBarController = base as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
    
    static func randomDigitStringAsDeviceKey() -> String {
        if let key = userDefaults.string(forKey: "DigitalBankDeviceKeySignature") {
            return key
        } else {
            let min: UInt32 = 100_000_000
            let max: UInt32 = 999_999_999
            let key = "\(min + arc4random_uniform(max - min + 1))"
            userDefaults.setValue(key, forKey: "DigitalBankDeviceKeySignature")
            userDefaults.synchronize()
            return key
        }
    }
    
    static func openWebView(url: URL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
