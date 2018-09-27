# EWPopMenu
### Swift.弹出菜单

# 实现效果:
点击弹出小型列表菜单.
view.frame,初始位置等都可通过调用方法自定制.
实现cell数量自适应,当数量大于4时,view高度固定,可滑动.
cell实现纯文字与icon+文字两种状态.自适应.
通过回调响应点击方法.
点任意位置菜单消失.
<br>

![效果图预览](https://github.com/WangLiquan/EWPopMenu/raw/master/image/demonstration.gif)

# 使用方法:
将EWPopMenu文件夹拖入项目,调用时:
```
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
```
