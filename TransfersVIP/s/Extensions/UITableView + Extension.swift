//
//  File.swift
//  VidMeTest
//
//  Created by Nikola Andriiev on 23.11.16.
//  Copyright © 2016 Andriiev.Mykola. All rights reserved.
//

import Foundation
import UIKit

extension UITableView  {
    func update(_ block: () -> ()) {
        self.beginUpdates()
            block()
        self.endUpdates()
    }
    
    func updateSilently(_ block: (() -> ())?){
        UIView.setAnimationsEnabled(false)
        self.beginUpdates()
        block?()
        self.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    // DESC: cls name should match with cell identifier
    func registerCell<T: UITableViewCell>(withClass cls: T.Type) {
        let name = String(describing: cls.self)
        let cell = UINib.init(nibName: name, bundle: nil)
        self.register(cell, forCellReuseIdentifier: name)
    }
    
    func registerHeader(withClass cls: AnyClass?) {
        if let cls = cls {
            let name = String(describing: cls.self)
            let nib = UINib.init(nibName: name, bundle: nil)
            self.register(nib, forHeaderFooterViewReuseIdentifier: name)
        }
    }
    
    func dequeueHeader<T>(cls: T.Type) -> T {
        let clsString = String(describing: T.self)
        return self.dequeueReusableHeaderFooterView(withIdentifier: clsString) as! T
    }
    
    func dequeueCell<T>(cls: T.Type, indexPath path: IndexPath) -> T {
        let clsString = String(describing: T.self)
        return self.dequeueReusableCell(withIdentifier: clsString, for: path) as! T
    }
    
    func rowAutoHeight(estimatedRowHeight : CGFloat) {
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = estimatedRowHeight
    }
}
