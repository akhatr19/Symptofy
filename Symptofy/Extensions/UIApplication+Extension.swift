//
//  UIApplication+Extension.swift
//  Symptofy
//
//  Created by Aarav Khatri on 8/5/23.
//

import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    
    func getNavigationController() -> UINavigationController? {
        guard let window = keyWindow else { return nil }
        guard let rootViewController = window.rootViewController else { return nil }
        guard let navigationController = findNavigationController(viewController: rootViewController) else { return nil }
        return navigationController
    }
    
    private func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
    }
    
    func popToView(_ identifier: String) {
        guard let navigationController = getNavigationController() else {
            return
        }
        
        for vc in navigationController.children {
            if vc.navigationItem.title == identifier {
                navigationController.popToViewController(vc, animated: true)
                break
            }
        }
    }
}
