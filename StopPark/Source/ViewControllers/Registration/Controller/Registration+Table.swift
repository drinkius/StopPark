//
//  Registration+Table.swift
//  StopPark
//
//  Created by Arman Turalin on 2/6/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource
extension RegistrationVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataCount = sections[indexPath.section].rows.count
        switch sections[indexPath.section].rows[indexPath.row] {
        case let .form(data):
            let cell: TextFieldCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with: data, dataCount: dataCount, cellIndex: indexPath.row, delegate: self)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension RegistrationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].rows[indexPath.row] {
        case let .form(data):
            guard let textFieldCell = cell as? TextFieldCell else { return }
            textFieldCell.textFieldText = nil
            guard let text = UserDefaultsManager.getFormData(data) else { return }
            textFieldCell.textFieldText = text
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView()
        switch sections[section].type {
        case let .privacy(text): headerView.fill(with: text)
        case let .contacts(text): headerView.fill(with: text)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch sections[section].type {
        case .contacts:
            let messageFooterView = MessageFooterView()
            messageFooterView.fill(with: Str.Generic.privacyInfo)
            return messageFooterView
        default: return UIView()
        }
    }
}
