//
//  JJProxy.swift
//  SwiftTools
//
//  Created by 播呗网络 on 2021/8/31.
//  Copyright © 2021 xuanhe. All rights reserved.
//

import Foundation


enum JJImageSource {
    case SERVER(url:URL)
    case LOCAL(name:String)
}
enum JJImageType:Int {
    case SYSTOM
    case CUSTOM
}

enum JJScrollDirection {
    case horizontal
    case vertical
}

struct Proxy {
    var imgType:JJImageType = .SYSTOM
    var imageArray:[JJImageSource] = [JJImageSource]()
    
    // 下标法获取imageArray中对应的imageSource, eg:proxy[0] == imageArray[0]
    subscript (index:Int) -> JJImageSource{
        get {
            return imageArray[index]
        }
    }
    
    init(type:JJImageType, array:[String]) {
        imgType = type
        if imgType == .CUSTOM {
            return
        }
         
        imageArray = array.map({ imageName in
            if imageName.contains("http") {
                if let url = URL(string: imageName) {
                    return JJImageSource.SERVER(url: url)
                }
                return JJImageSource.LOCAL(name: imageName)
            }else{
                return JJImageSource.LOCAL(name: imageName)
            }
        })
    }
}


// MARK: - PageControl

enum JJPageControlAliment {
    case CenterBottom
    case LeftBottom
    case RightBottom
}

protocol PageControlAlimentProtocol {

    /// 是否显示PageControl
    var showPageControl: Bool { get set }
    /// 当前点的大小
    var currentPointSize: CGSize { get set }
    /// 其他点的大小
    var otherPointSize: CGSize { get set }
    /// 点-切圆角
    var pointCornerRadius:CGFloat { get set }
    /// 位置
    var pageControlAliment: JJPageControlAliment { get set }
    
    ///点的间距
    var pageControlPointSpace: CGFloat { get set }
    ///左右间距
    var pageControlLeftAndRightSpacing:CGFloat { get set }
    /// 其他点未选中颜色
    var pageControlOtherColor: UIColor { get set }
    /// 当前点颜色
    var pageControlCurrentColor: UIColor { get set }
    ///当前选中点的layer宽
    var pageControlCurrentLayerBorderWidth: CGFloat? { get set }
    ///其他点的layer宽
    var pageControlOtherLayerBorderWidth: CGFloat? { get set }
    ///当前选中点的layer颜色
    var pageControlCurrentLayerBorderColor: UIColor? { get set }
    ///其他选中点的layer颜色
    var pageControlOtherLayerBorderColor: UIColor? { get set }
    
    
    /// 其他点背景图片
    var pageControlOtherBkImage: UIImage? { get set }
    /// 当前点背景图片
    var pageControlCurrentBkImage: UIImage? { get set }
    /// 当只有一个点的时候是否隐藏
    var hidesPageControlForSinglePage:Bool { get set }
    /// 是否可以点击 默认不可以点击
    var isCanClickPageControlPoint: Bool { get set }
    var pageControlFrame:CGRect? { get set }

}


protocol EndlessScrollProtocol {
    
    /// 是否自动滚动
    var isAutoScroll :Bool { get set }
    /// 自动滚动时间间隔
    var autoScrollInterval: Double { get set }
    /// 图片类型
    var imageType:JJImageType{ get set }
    
    /** 设置定时器，用于自动滚动 */
    func setupTimer()
     
}








































































