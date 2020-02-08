//
//  Home+View.swift
//  StopPark
//
//  Created by Arman Turalin on 2/9/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

// MARK: - ProfileViewDelegate
extension HomeVC: ProfileViewDelegate {
    func openForm() {
        guard Reachability.isConnectedToNetwork() else {
            showErrorMessage(Str.Generic.noConnection)
            return
        }
        InvAnalytics.shared.sendEvent(event: .homeClickForm)
        Vibration.light.vibrate()
        let context = HomeRouter.RouteContext.form
        router.enqueueRoute(with: context)
    }
}
