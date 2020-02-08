//
//  Form+Table.swift
//  StopPark
//
//  Created by Arman Turalin on 2/5/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource
extension FormVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataCount = sections[indexPath.section].rows.count
        switch sections[indexPath.section].rows[indexPath.row] {
        case let .privacy(data):
            let cell: ClosedTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with: data, dataCount: dataCount, cellIndex: indexPath.row)
            return cell
        case let .form(data):
            let cell: TextFieldCell = tableView.dequeueReusableCell(for: indexPath)
            cell.pickerDelegate = self
            cell.fill(with: data, dataCount: dataCount, cellIndex: indexPath.row, delegate: self)
            return cell
        case let .time(data):
            let cell: TimePickerCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with: data, dataCount: dataCount, cellIndex: indexPath.row, delegate: self)
            return cell
        case .image:
            let cell: ImagesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.fill(with: eventImages, destination: .single, delegate: self)
            return cell
        case .button:
            let cell: ButtonTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension FormVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].rows[indexPath.row] {
        case .form: tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].rows[indexPath.row] {
        case let .form(data):
            guard let textFieldCell = cell as? TextFieldCell else { return }
            textFieldCell.textFieldText = eventInfoForm[data]
        case .image:
            guard let imagesCell = cell as? ImagesTableViewCell else { return }
            imagesCell.fill(with: eventImages, destination: .single, delegate: self)
        default: break
        }
    }
            
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].rows[indexPath.row] {
        case .privacy, .form, .time: return UITableView.automaticDimension
        case .image: return 80.0 + (2 * .padding)
        case .button: return 44.0 + (2 * .nanoPadding)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView()
        switch sections[section].type {
        case let .from(text): headerView.fill(with: text)
        case let .to(text): headerView.fill(with: text)
        case let .messageData(text): headerView.fill(with: text)
        case let .images(text): headerView.fill(with: text)
        default: break
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch sections[section].type {
        case .messageData:
            let footerView = ButtonFooterView()
            footerView.fill(with: self)
            return footerView
        default: return nil
        }
    }
}
