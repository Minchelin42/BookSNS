//
//  FollowViewController.swift
//  BookSNS
//
//  Created by 민지은 on 2024/04/25.
//

import UIKit
import Tabman
import Pageboy
import RxSwift
import RxCocoa

enum Follow {
    case following
    case follower
}

class FollowViewController: TabmanViewController {
    
    let followerVC = FollowListViewController()
    let followingVC = FollowListViewController()
    
    var userID: String = ""
    var selectType: Follow = .following
    
    lazy var viewControllers = [followingVC, followerVC]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followerVC.type = .follower
        followerVC.userID = self.userID
        
        followingVC.userID = self.userID
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        settingTabman(bar: bar)
        addBar(bar, dataSource: self, at: .top)
        
    }

    func settingTabman(bar: TMBar.ButtonBar) {
        bar.layout.transitionStyle = .snap

        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = Color.mainColor
        
        bar.layout.alignment = .centerDistributed
        bar.layout.interButtonSpacing = view.bounds.width / 4
        
        bar.buttons.customize { (button) in
            button.tintColor = Color.lightPoint
            button.selectedTintColor = Color.mainColor
            button.verticalAlignment = .center
            button.addAction(UIAction(handler: { action in
         
            }), for: .touchUpInside)
        }
        bar.indicator.overscrollBehavior = .compress
        bar.backgroundView.style = .clear
        bar.backgroundColor = .white
    }
}

extension FollowViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        if (selectType == .following) {
            return .at(index: 0)
        } else {
            return .at(index: 1)
        }
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        let title: String = index == 0 ? "팔로잉" : "팔로워"
        item.title = title
        
        return item
    }
    
}
