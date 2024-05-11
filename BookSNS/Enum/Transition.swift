//
//  Transition.swift
//  BookSNS
//
//  Created by 민지은 on 2024/05/11.
//

import UIKit

enum Transition {
    static func push (nowVC: UIViewController, toVC: UIViewController) {
        nowVC.navigationController?.pushViewController(toVC, animated: true)
    }
    
    static func present (nowVC: UIViewController, toVC: UIViewController) {
        nowVC.present(toVC, animated: true)
    }
    
    static func pop (_ nowVC: UIViewController) {
        nowVC.navigationController?.popViewController(animated: true)
    }
    
    static func dismiss (_ nowVC: UIViewController) {
        nowVC.dismiss(animated: true)
    }
    
    static func sheet(nowVC: UIViewController, toVC: UIViewController) {
        let nav = UINavigationController(rootViewController: toVC)
          if let sheet = nav.sheetPresentationController {
              sheet.detents = [.medium(), .large()]
              sheet.prefersGrabberVisible = true
          }
    
        nowVC.present(nav, animated: true)
    }
}
