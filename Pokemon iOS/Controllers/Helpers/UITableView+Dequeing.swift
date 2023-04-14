//
//  UITableView+Dequeing.swift
//  Pokemon iOS
//
//  Created by Victor Arana on 4/13/23.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
