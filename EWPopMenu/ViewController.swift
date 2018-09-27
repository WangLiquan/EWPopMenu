//
//  ViewController.swift
//  EWPopMenu
//
//  Created by Ethan.Wang on 2018/9/27.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "demo"
        self.view.backgroundColor = UIColor.gray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "pop", style: .done, target: self, action: #selector(onClickPop))
    }

    @objc private func onClickPop(){
        let items: [String] = ["测试1","测试2"]
        let imgSource: [String] = ["test1","test2"]
        NavigationMenuShared.showPopMenuSelecteWithFrameWidth(width: itemWidth, height: 160, point: CGPoint(x: ScreenInfo.Width - 30, y: 0), item: items, imgSource: imgSource) { (index) in
            ///点击回调
            switch index{
            case 0:
                EWToast.showCenterWithText(text: "点击测试1")
            case 1:
                EWToast.showCenterWithText(text: "点击测试2")
            default:
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

