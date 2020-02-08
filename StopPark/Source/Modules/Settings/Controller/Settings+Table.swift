//
//  Settings+Table.swift
//  StopPark
//
//  Created by Arman Turalin on 2/6/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource
extension SettingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].rows[indexPath.row] {
        case .privacy:
            let cell: ProfileTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.updateValues()
            return cell
        case .setting:
            let cell: SettingCell = tableView.dequeueReusableCell(for: indexPath)
            cell.textLabel?.text = sections[indexPath.section].rows[indexPath.row].title
            cell.textLabel?.font = .systemFont(ofSize: 14)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView()
        headerView.fill(with: sections[section].type.title)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch sections[section].type {
        case .additional:
            let footerView = MessageFooterView()
            let appVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0"
            footerView.fill(with: Str.Generic.appVersion + appVersion)
            return footerView
        default: return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].rows[indexPath.row] {
        case .privacy:
            InvAnalytics.shared.sendEvent(event: .settingsClickChangeProfile)
            let context = SettingsRouter.RouteContext.profile
            router.enqueueRoute(with: context)
        case .setting:
            InvAnalytics.shared.sendEvent(event: .settingsClickInfo)
            let context = SettingsRouter.RouteContext.info
            router.enqueueRoute(with: context)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }

}
