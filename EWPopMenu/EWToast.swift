//
//  EWToast.swift
//  EWToast
//
//  Created by Ethan.Wang on 2018/9/11.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit
///Toast默认停留时间
let ToastDispalyDuration: CGFloat = 2.0
///Toast背景颜色
let ToastBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)

class EWToast: NSObject {

    var _contentView: UIButton
    var _duration: CGFloat = ToastDispalyDuration

    init(text: String) {
        let rect = text.boundingRect(with: CGSize(width: 250, height: CGFloat.greatestFiniteMagnitude), options:[NSStringDrawingOptions.truncatesLastVisibleLine, NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: rect.size.width + 40, height: rect.size.height + 20))
        textLabel.backgroundColor = UIColor.clear
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 16)
        textLabel.text = text
        textLabel.numberOfLines = 0

        _contentView = UIButton(frame: CGRect(x: 0, y: 0, width: textLabel.frame.size.width, height: textLabel.frame.size.height))
        _contentView.layer.cornerRadius = 2.0
        _contentView.backgroundColor = ToastBackgroundColor
        _contentView.addSubview(textLabel)
        _contentView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        super.init()
        _contentView.addTarget(self, action: #selector(toastTaped), for: .touchDown)
        ///添加通知获取手机旋转状态.保证正确的显示效果
        NotificationCenter.default.addObserver(self, selector: #selector(toastTaped), name: UIDevice.orientationDidChangeNotification, object: UIDevice.current)
    }
    @objc func toastTaped(){
        self.hideAnimation()
    }
    func deviceOrientationDidChanged(notify: Notification){
        self.hideAnimation()
    }
    @objc func dismissToast(){
        _contentView.removeFromSuperview()
    }
    func setDuration(duration: CGFloat){
        _duration = duration
    }
    func showAnimation(){
        UIView.beginAnimations("show", context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeIn)
        UIView.setAnimationDuration(0.3)
        _contentView.alpha = 1.0
        UIView.commitAnimations()
    }
    @objc func hideAnimation(){
        UIView.beginAnimations("hide", context: nil)
        UIView.setAnimationCurve(UIView.AnimationCurve.easeOut)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(dismissToast))
        UIView.setAnimationDuration(0.3)
        _contentView.alpha = 0.0
        UIView.commitAnimations()
    }

    func show(){
        let window: UIWindow = UIApplication.shared.windows.last!
        _contentView.center = window.center
        window.addSubview(_contentView)
        self.showAnimation()
        self.perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(_duration))
    }
    func showFromTopOffset(top: CGFloat){
        let window: UIWindow = UIApplication.shared.windows.last!
        _contentView.center = CGPoint(x: window.center.x, y: top + _contentView.frame.size.height/2)
        window.addSubview(_contentView)
        self.showAnimation()
        self.perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(_duration))
    }
    func showFromBottomOffset(bottom: CGFloat){
        let window: UIWindow = UIApplication.shared.windows.last!
        _contentView.center = CGPoint(x: window.center.x, y: window.frame.size.height - (bottom + _contentView.frame.size.height/2))
        window.addSubview(_contentView)
        self.showAnimation()
        self.perform(#selector(hideAnimation), with: nil, afterDelay: TimeInterval(_duration))
    }
    //MARK: 中间显示
    class func showCenterWithText(text: String){
        EWToast.showCenterWithText(text: text, duration: CGFloat(ToastDispalyDuration))
    }
    class func showCenterWithText(text: String, duration: CGFloat){
        let toast: EWToast = EWToast(text: text)
        toast.setDuration(duration: duration)
        toast.show()
    }
    //MARK: 上方显示
    class func showTopWithText(text: String){
        EWToast.showTopWithText(text: text, topOffset: 100.0, duration: ToastDispalyDuration)
    }
    class func showTopWithText(text: String, duration: CGFloat){
        EWToast.showTopWithText(text: text, topOffset: 100, duration: duration)
    }
    class func showTopWithText(text: String, topOffset: CGFloat){
        EWToast.showTopWithText(text: text, topOffset: topOffset, duration: ToastDispalyDuration)
    }
    class func showTopWithText(text: String, topOffset: CGFloat, duration: CGFloat){
        let toast = EWToast(text: text)
        toast.setDuration(duration: duration)
        toast.showFromTopOffset(top: topOffset)
    }
    //MARK: 下方显示
    class func showBottomWithText(text: String){
        EWToast.showBottomWithText(text: text, bottomOffset: 100.0, duration: ToastDispalyDuration)
    }
    class func showBottomWithText(text: String, duration: CGFloat){
        EWToast.showBottomWithText(text: text, bottomOffset: 100.0, duration: duration)
    }
    class func showBottomWithText(text: String, bottomOffset: CGFloat){
        EWToast.showBottomWithText(text: text, bottomOffset: bottomOffset, duration: ToastDispalyDuration)
    }
    class func showBottomWithText(text: String, bottomOffset: CGFloat, duration: CGFloat){
        let toast = EWToast(text: text)
        toast.setDuration(duration: duration)
        toast.showFromBottomOffset(bottom: bottomOffset)
    }
}
