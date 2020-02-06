//
//  SettingsRouter.swift
//  StopPark
//
//  Created by Arman Turalin on 2/6/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class SettingsRouter: RouterProtocol {
    
    weak var baseViewController: UIViewController?
    
    func present(on baseVC: UIViewController, animated: Bool, context: Any) {
        guard let context = context as? PresentationContext else {
            assertionFailure("The context type mismatch")
            return
        }
        
        guard let navigationController = baseVC.navigationController else {
            assertionFailure("Navigation controller is not set")
            return
        }
                
        baseViewController = baseVC
        
        switch context {
        case .default:
            let vc = SettingsVC(router: self)
            DispatchQueue.main.async {
                navigationController.pushViewController(vc, animated: animated)
            }
        }
    }
    
    func enqueueRoute(with context: Any, animated: Bool) {
        guard let routeContext = context as? RouteContext else {
            assertionFailure("The route type mismatch")
            return
        }
        
        guard let baseVC = baseViewController else {
            assertionFailure("baseViewController is not set")
            return
        }
        
        switch routeContext {
        case .profile:
            let router = RegistrationRouter()
            let context = RegistrationRouter.PresentationContext.profile
            router.present(on: baseVC, animated: animated, context: context)
        case .info:
            let router = InfoRouter()
            let context = InfoRouter.PresentationContext.default
            router.present(on: baseVC, animated: animated, context: context)
        }
    }
    
    func dismiss(animated: Bool) { }

}

// MARK: - Support
extension SettingsRouter {
    enum PresentationContext {
        case `default`
    }
    
    enum RouteContext {
        case profile
        case info
    }
}
