//
//  UITableView + LongPressMoveRow.swift
//  DigitalBank
//
//  Created by Nikola Andriiev on 5/1/17.
//  Copyright © 2017 iosDeveloper. All rights reserved.
//

import UIKit

protocol LongPressMoveRow {
    var tableView: UITableView { get }
    var buffer: [AnyObject] { get set }
    var longPress: UILongPressGestureRecognizer { get }
    func cellLongPressGestureRecognized(sender: UILongPressGestureRecognizer)
}

extension LongPressMoveRow where Self: UIViewController {
    mutating func cellLongPressGestureRecognized(sender: UILongPressGestureRecognizer) {
        let state = sender.state
        let location = sender.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: location)
        
        var snapshot: UIView?
        var sourceIndexPath: IndexPath?
        
        switch state {
        case .began:
            guard let path = indexPath else { break }
            sourceIndexPath = path
            guard let cell = self.tableView.cellForRow(at: path) else { break }
            var cellCenter = cell.center
            let cellSnapshot = cell.snapshot()
            snapshot = cellSnapshot
            cellSnapshot.center = cellCenter;
            cellSnapshot.alpha = 0.0;
            self.tableView.addSubview(cellSnapshot)
            UIView.animate(withDuration: 0.25, animations: {
                cellCenter.y = location.y
                cellSnapshot.center = cellCenter;
                cellSnapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05);
                cellSnapshot.alpha = 0.98;
                cell.alpha = 0.0;
            }, completion: { (finished) in
                cell.isHidden = true;
            })
        case .changed:
            guard let sourcePath = sourceIndexPath else { break }
            var center = snapshot?.center
            center?.y = location.y
            guard let path = indexPath, path != sourceIndexPath else { break }
            buffer.swapAt(sourcePath.row, path.row)
            self.tableView.moveRow(at: sourcePath, to: path)
            sourceIndexPath = path
        default:
            guard let sourcePath = sourceIndexPath else { break }
            guard let cell =  self.tableView.cellForRow(at: sourcePath) else { break }
            cell.isHidden = false;
            cell.alpha = 0.0;
            
            UIView.animate(withDuration:  0.25, animations: {
                snapshot?.center = cell.center;
                snapshot?.transform = CGAffineTransform.identity
                snapshot?.alpha = 0.0;
                cell.alpha = 1.0
            }, completion: { _ in
                sourceIndexPath = nil
                snapshot?.removeFromSuperview()
                snapshot = nil
            })
        }
    }
}
