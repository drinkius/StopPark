//
//  EditorRouter.swift
//  StopPark
//
//  Created by Arman Turalin on 2/6/20.
//  Copyright © 2020 tech.telegin. All rights reserved.
//

import UIKit

class EditorRouter: RouterProtocol {
    
    weak var baseViewController: UIViewController?
    
    func present(on baseVC: UIViewController, animated: Bool, context: Any) {
        guard let context = context as? PresentationContext else {
            assertionFailure("The context type mismatch")
            return
        }
                
        switch context {
        case let .`default`(message, actionBlock):
            let vc = EditorVC(router: self)
            vc.actionBlock = actionBlock
            vc.generatedMessage = message
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            DispatchQueue.main.async {
                baseVC.present(vc, animated: animated)
            }
        }
    }
    
    func enqueueRoute(with context: Any, animated: Bool) { }
    
    func dismiss(animated: Bool) { }

}

// MARK: - Support
extension EditorRouter {
    enum PresentationContext {
        case `default`(message: String, actionBlock: ((String?) -> Void)?)
    }
    
    enum RouteContext {
    }
}
