//
//  UIRefreshController+Helpers.swift
//  Pokemon iOS
//
//  Created by Victor Arana on 4/13/23.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
