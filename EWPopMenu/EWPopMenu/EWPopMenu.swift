//
//  EWPopMenu.swift
//  EWPopMenu
//
//  Created by Ethan.Wang on 2018/9/27.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit

let NavigationMenuShared = EWPopMenu.shared

class EWPopMenu: NSObject {
    static let shared = EWPopMenu()
    private var menuView: EWPopMenuView?

    public func showPopMenuSelecteWithFrameWidth(width: CGFloat, height: CGFloat, point: CGPoint, item: [String], imgSource: [String], action: @escaping ((Int) -> Void)) {
        weak var weakSelf = self
        /// 每次重置保证显示效果
        if self.menuView != nil {
            weakSelf?.hideMenu()
        }
        let window = UIApplication.shared.windows.first
        self.menuView = EWPopMenuView(width: width, height: height, point: point, items: item, imgSource: imgSource, action: { (index) in
            ///点击回调
            action(index)
            weakSelf?.hideMenu()
        })
        menuView?.touchBlock = {
            weakSelf?.hideMenu()
        }
        self.menuView?.backgroundColor = UIColor.black.withAlphaComponent(0)
        window?.addSubview(self.menuView!)
    }
    public func hideMenu() {
        self.menuView?.removeFromSuperview()
        self.menuView = nil
    }
}
