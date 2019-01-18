//
//  MovieListTableViewController+MainTabBarDelegate.swift
//  BoxOffice
//
//  Created by 강준영 on 13/12/2018.
//  Copyright © 2018 강준영. All rights reserved.
//

import Foundation

extension MovieListTableViewController: MainTabBarDelegate {
    func titleChange() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
