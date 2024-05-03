//
//  CustomTabBarController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/30.
//

import UIKit

class CustomTabBarController : UITabBarController {
    let btnMiddle : UIButton = {
       let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        btn.setTitle("", for: .normal)
        btn.backgroundColor = Color.mainColor
        btn.layer.cornerRadius = 35
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.setImage(UIImage(named: "Book"), for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
  
        addSomeTabItems()
        btnMiddle.frame = CGRect(x: Int(self.tabBar.bounds.width)/2 - 35, y: -25, width: 70, height: 70)
    }
    override func loadView() {
        super.loadView()
        
        setupCustomTabBar()
        self.tabBar.addSubview(btnMiddle)
    }
    func setupCustomTabBar() {
        let path : UIBezierPath = getPathForTabBar()
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 3
        shape.strokeColor = Color.lightPoint?.cgColor
        shape.fillColor = UIColor.white.cgColor
        
        self.tabBar.layer.insertSublayer(shape, at: 0)
        self.tabBar.itemWidth = 40
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = 100
        self.tabBar.tintColor = Color.mainColor
    }
    
    func addSomeTabItems() {
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let createVC = UINavigationController(rootViewController: CreatePostViewController())
        let marketVC = UINavigationController(rootViewController: MarketHomeViewController())
        let myProfileVC = UINavigationController(rootViewController: ProfileViewController())
     

        setViewControllers([homeVC, searchVC, createVC, marketVC, myProfileVC], animated: false)
        guard let items = tabBar.items else { return }
        items[0].image = UIImage(systemName: "house.fill")
        items[1].image = UIImage(systemName: "magnifyingglass")
        items[2].image = nil
        items[3].image = UIImage(systemName: "cart.fill")
        items[4].image = UIImage(systemName: "person.fill")
    }
    
    func getPathForTabBar() -> UIBezierPath {
        let frameWidth = self.tabBar.bounds.width
        let frameHeight = self.tabBar.bounds.height + 40
        let holeWidth = 150
        let holeHeight = 50
        let leftXUntilHole = Int(frameWidth/2) - Int(holeWidth/2)
        
        let path : UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: leftXUntilHole , y: 0)) // 1.Line
        path.addCurve(to: CGPoint(x: leftXUntilHole + (holeWidth/3), y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*6,y: 0), controlPoint2: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*8, y: holeHeight/2)) // part I
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + (2*holeWidth)/3, y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2/5, y: (holeHeight/2)*6/4), controlPoint2: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2 + (holeWidth/3)/3*3/5, y: (holeHeight/2)*6/4)) // part II
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + holeWidth, y: 0), controlPoint1: CGPoint(x: leftXUntilHole + (2*holeWidth)/3,y: holeHeight/2), controlPoint2: CGPoint(x: leftXUntilHole + (2*holeWidth)/3 + (holeWidth/3)*2/8, y: 0)) // part III
        path.addLine(to: CGPoint(x: frameWidth, y: 0)) // 2. Line
        path.addLine(to: CGPoint(x: frameWidth, y: frameHeight)) // 3. Line
        path.addLine(to: CGPoint(x: 0, y: frameHeight)) // 4. Line
        path.addLine(to: CGPoint(x: 0, y: 0)) // 5. Line
        path.close()
        return path
    }
}


extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }

        if selectedIndex == 2 {
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
 
            let postButton = UIAlertAction(title: "내 책 소개", style: .default) { action in
                let nav = UINavigationController(rootViewController: CreatePostViewController())
                self.present(nav, animated: true)
            }
            let marketButton = UIAlertAction(title: "내 책 팔기", style: .default) { action in
                let nav = UINavigationController(rootViewController: MarketPostViewController())
                self.present(nav, animated: true)
            }
            let cancelButton = UIAlertAction(title: "취소", style: .cancel)
            
            
            sheet.addAction(postButton)
            sheet.addAction(marketButton)
            sheet.addAction(cancelButton)

            present(sheet, animated: true)
            return false
        }
        
        return true
    }
}


#Preview {
    CustomTabBarController()
}
