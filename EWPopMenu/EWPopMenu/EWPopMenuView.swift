//
//  EWPopMenuView.swift
//  EWPopMenu
//
//  Created by Ethan.Wang on 2018/9/27.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit
/// 屏幕frame相关便捷方法
struct ScreenInfo {
    static let Frame = UIScreen.main.bounds
    static let Height = Frame.height
    static let Width = Frame.width
    static let navigationHeight:CGFloat = navBarHeight()
    static func isIphoneX() -> Bool {
        return UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 812))
    }
    static private func navBarHeight() -> CGFloat {
        return isIphoneX() ? 88 : 64;
    }
}
/// 默认的cell高度宽度,可修改
let itemHeight: CGFloat = 36.0
let itemWidth: CGFloat = 113.0

class EWPopMenuView: UIView {
    public var touchBlock: (()->())?
    /// 点击cell回调
    public var indexBlock: ((Int)->())?
    /// 起始点,tableView上三角形的顶部
    private var point:CGPoint?
    /// tableView.height
    private var layerHeight: CGFloat?
    /// tableView.width
    private var layerWidth: CGFloat?
    /// cell标题array
    private var titleSource: [String] = []
    /// cell图片array
    private var imgSource: [String] = []

    private var tableView: UITableView = UITableView()
    /// init
    ///
    /// - Parameters:
    ///   - width: tableView.width
    ///   - height: tableView最大height,如果cell数量大于4,则是tableView.frame.size.height
    ///   - point: 初始点,tableView上的三角形的顶点
    ///   - items: 每个cell的title数组
    ///   - imgSource: 每个cell的icon数组,可为空
    ///   - action: 回调方法
    init(width: CGFloat, height: CGFloat, point: CGPoint, items: [String], imgSource: [String],  action: ((Int) -> ())?){
        super.init(frame:CGRect(x: 0, y: 0, width: ScreenInfo.Width, height: ScreenInfo.Height))
        drawMyTableView()
        /// view全屏展示
        self.frame = CGRect(x: 0, y: 0, width: ScreenInfo.Width, height: ScreenInfo.Height)
        /// 获取起始点
        self.point = CGPoint(x: point.x, y: ScreenInfo.navigationHeight + point.y)
        /// tableView高度由init方法传入
        self.layerWidth = width
        self.titleSource.removeAll()
        self.titleSource += items
        self.imgSource.removeAll()
        self.imgSource += imgSource
        /// 如果图片数组与标题数组数量不符,则不展示图片
        if imgSource.count != titleSource.count{
            self.imgSource.removeAll()
        }
        /// 如果没有图片展示,则将tabelView宽度控制在100
        if imgSource.count == 0{
            self.layerWidth = 100
        }
        /// 弱引用防止闭包循环引用
        weak var weakSelf = self
        if action != nil{
            weakSelf?.indexBlock = { row in
                /// 点击cell回调,将点击cell.indexpath.row返回
                action!(row)
            }
        }
        /// tableView高度,如果大于4个则为4个itemHeight,使tableView可滑动,如果小于4个则动态显示
        self.layerHeight = titleSource.count > 4 ? height : CGFloat(CGFloat(items.count) * itemHeight)
        self.addSubview(self.tableView)
        /// 将tableView.frame更新,使其在展示正确效果
        let y1 = (self.point?.y)! + 10
        let x2 = (self.point?.x)! - self.layerWidth! + 20
        tableView.frame = CGRect(x: x2, y: y1, width: self.layerWidth!, height: self.layerHeight!)
        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func drawMyTableView(){
        tableView.separatorStyle = .none;
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.showsHorizontalScrollIndicator = true
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.66)
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = true
        tableView.register(EWMenuTableViewCell.self, forCellReuseIdentifier: EWMenuTableViewCell.identifier)
    }
    /// drawRect方法,画tableView上的小三角形
    override func draw(_ rect: CGRect) {
        let y1 = (self.point?.y)! + 10
        let x1 = (self.point?.x)! - 10
        let x2 = (self.point?.x)! + 10

        UIColor(white: 0, alpha: 0.66).set()

        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        context?.move(to: CGPoint(x: (self.point?.x)!, y: (self.point?.y)!))
        context?.addLine(to: CGPoint(x: x1, y: y1))
        context?.addLine(to: CGPoint(x: x2, y: y1))
        context?.closePath()
        context?.fillPath()
        context?.drawPath(using: .stroke)
    }
    /// 点击屏幕任意位置menu消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.touchBlock != nil{
            touchBlock!()
        }
    }

}
extension EWPopMenuView:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:  EWMenuTableViewCell.identifier) as? EWMenuTableViewCell else {
            return EWMenuTableViewCell()
        }
        cell.setContentBy(titArray: self.titleSource, imgArray: self.imgSource, row: indexPath.row)
        cell.conLabel.text = self.titleSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexBlock!(indexPath.row)
    }
}


