//
//  HomeRouter.swift
//  StopPark
//
//  Created by Arman Turalin on 2/6/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class HomeRouter: RouterProtocol {
    
    weak var baseViewController: UIViewController?
    
    func present(on baseVC: UIViewController, animated: Bool, context: Any) {
        guard let context = context as? PresentationContext else {
            assertionFailure("The context type mismatch")
            return
        }
                
        baseViewController = baseVC
        
        switch context {
        case .default:
            let router = HomeRouter()
            let vc = HomeVC(router: router)
            let nav = CustomNavigationController(rootViewController: vc)
            router.baseViewController = vc
            nav.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                baseVC.present(nav, animated: animated)
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
        case .form:
            let router = FormRouter()
            let context = FormRouter.PresentationContext.default
            router.present(on: baseVC, animated: animated, context: context)
        case .donate:
            let router = PayRouter()
            let context = PayRouter.PresentationContext.donate
            router.present(on: baseVC, animated: animated, context: context)
        case .settings:
            let router = SettingsRouter()
            let context = SettingsRouter.PresentationContext.default
            router.present(on: baseVC, animated: animated, context: context)
        }
    }
    
    func dismiss(animated: Bool) { }

}

// MARK: - Support
extension HomeRouter {
    enum PresentationContext {
        case `default`
    }
    
    enum RouteContext {
        case form
        case donate
        case settings
    }
}
