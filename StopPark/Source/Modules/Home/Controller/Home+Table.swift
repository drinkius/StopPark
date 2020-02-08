//
//  Home+Table.swift
//  StopPark
//
//  Created by Arman Turalin on 2/8/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rows[indexPath.row] {
        case let .statement(appeal):
            let cell: RequestTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with: appeal)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView()
        headerView.fill(with: Str.Home.previousStatements)
        return headerView
    }
}
