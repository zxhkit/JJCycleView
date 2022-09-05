//
//  JJCycleView.swift
//  SwiftTools
//
//  Created by 播呗网络 on 2021/7/14.
//  Copyright © 2021 xuanhe. All rights reserved.
//

import UIKit



@objc protocol JJCycleViewDelegate {
    //点击图片回调
    @objc optional func cycleViewDidSelect(at index: Int, cycleView: JJCycleView);
    //图片滚动回调
    @objc optional func cycleViewDidScroll(to index: Int, cycleView: JJCycleView);
    
    
    /// 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的class。
    @objc optional func customCollectionViewCellClassNameForCycleView(cycleView: JJCycleView) -> (AnyClass)
    /// 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的Nib
    @objc optional func customCollectionViewCellNibForCycleScrollView(cycleView: JJCycleView) -> (UINib)
    /// 如果你自定义了cell样式，请在实现此代理方法为你的cell填充数据以及其它一系列设置
    @objc optional func setupCustomView(cycleView: JJCycleView, cell:UICollectionViewCell, index: Int)
    
}

class JJCycleView: UIView, EndlessScrollProtocol, PageControlAlimentProtocol{
    /// 代理
    weak var delegate:JJCycleViewDelegate?{
        didSet{
            if let cal = delegate?.customCollectionViewCellClassNameForCycleView?(cycleView: self) {
                collectionView.register(cal, forCellWithReuseIdentifier: cellID)
            }
            if let nib = delegate?.customCollectionViewCellNibForCycleScrollView?(cycleView: self) {
                collectionView.register(nib, forCellWithReuseIdentifier: cellID)
            }
        }
    }
    /// 滚动时间间隔,最少1s
    var autoScrollInterval:Double = 3.0{
        didSet{
            invalidateTimer()
            if isAutoScroll == true {
                setupTimer()
            }
        }
    }
    /// 占位图
    var placeholderImage:UIImage? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    /// 轮播图类型
    var imageType: JJImageType = .SYSTOM {
        didSet{
            reloadData()
        }
    }
    /// 滚动方向
    var scrollDirrection: JJScrollDirection = .horizontal {
        didSet{
            setupCollectionView()
            reloadData()
        }
    }
    /// 是否自动滚动
    var isAutoScroll:Bool = false {
        didSet {
            invalidateTimer()
            if isAutoScroll == true {
                setupTimer()
            }
        }
    }
    /// 数据源
    var imageArray:[String]? {
        didSet {
            titles.removeAll()
            if let list = imageArray {
                proxy = Proxy(type: .SYSTOM, array: list)
                if list.count > 0 {
                    titles += list
                    titles.append(list.first!)
                    titles.insert(list.last!, at: 0)
                }
            }
            collectionView.contentOffset = CGPoint(x: collectionView.bounds.size.width, y: 0)
            pageControl?.numberOfPages = imageArray?.count ?? 0
            pageControl?.currentPage = 0
            collectionView.reloadData()
        }
    }
    
    /// 描述文字
    var descTextArray :[String]?

    /// JJCycleCell相关
    var imageContentModel: UIView.ContentMode?
    var descLabelFont: UIFont?
    var descLabelTextColor: UIColor?
    var descLabelHeight: CGFloat?
    var descLabelTextAlignment:NSTextAlignment?
    var bottomViewBackgroundColor: UIColor?
    
    /// 主要功能需求相关
    override var frame: CGRect {
        didSet {
           // flowLayout?.itemSize = frame.size
            collectionView.frame = bounds
        }
    }
    
    // MARK: - pageControl相关
    var showPageControl: Bool = true {
        didSet {
            setupPageControl()
        }
    }
    /// 当前点的大小
    var currentPointSize: CGSize = CGSize(width: 6, height: 6) {
        didSet {
            setupPageControl()
        }
    }
    /// 其他点的大小
    var otherPointSize: CGSize = CGSize(width: 6, height: 6) {
        didSet {
            setupPageControl()
        }
    }
    /// 点-切圆角
    var pointCornerRadius:CGFloat = 3 {
        didSet{
            setupPageControl()
        }
    }
    /// 位置
    var pageControlAliment: JJPageControlAliment = .CenterBottom {
        didSet{
            setupPageControl()
        }
    }
    
    ///点的间距
    var pageControlPointSpace: CGFloat = 8 {
        didSet{
            setupPageControl()
        }
    }
    ///左右间距
    var pageControlLeftAndRightSpacing: CGFloat = 10 {
        didSet{
            setupPageControl()
        }
    }
    /// 其他点未选中颜色
    var pageControlOtherColor: UIColor = .white {
        didSet{
            setupPageControl()
        }
    }
    /// 当前点颜色
    var pageControlCurrentColor: UIColor = .orange {
        didSet{
            setupPageControl()
        }
    }
    /// 其他点背景图片
    var pageControlOtherBkImage: UIImage? {
        didSet{
            setupPageControl()
        }
    }
    /// 当前点背景图片
    var pageControlCurrentBkImage: UIImage? {
        didSet{
            setupPageControl()
        }
    }
    /// 当只有一个点的时候是否隐藏
    var hidesPageControlForSinglePage = false {
        didSet{
            setupPageControl()
        }
    }
    /// 是否可以点击 默认不可以点击
    var isCanClickPageControlPoint = false {
        didSet{
            setupPageControl()
        }
    }
    var pageControlFrame:CGRect? {
        didSet {
            setupPageControl()
        }
    }
    
    
    var pageControlOtherLayerBorderColor: UIColor? {
        didSet{
            setupPageControl()
        }
    }
    var pageControlCurrentLayerBorderColor: UIColor?{
        didSet{
            setupPageControl()
        }
    }
    var pageControlOtherLayerBorderWidth: CGFloat? {
        didSet{
            setupPageControl()
        }
    }
    var pageControlCurrentLayerBorderWidth: CGFloat?{
        didSet{
            setupPageControl()
        }
    }
    
    
    // MARK: -----
    /// 轮换轮播主体
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let coll = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        coll.delegate = self
        coll.dataSource = self
        coll.isPagingEnabled = true
        coll.backgroundColor = .clear
        coll.register(JJCycleCell.classForCoder(), forCellWithReuseIdentifier:cellID)
        coll.showsHorizontalScrollIndicator = false
        //设置
        return coll
    }()
    
    
    /// cell注册标识符
    private let cellID = "JJCycleViewCellID"
    /// 私用的数据
    private var titles: [String] = []
    /// pageControl
    private var pageControl: JJPageControl?
    /// 定时器
    private var timer: Timer?
    
    fileprivate var proxy:Proxy!
    /// 当前下标
    fileprivate var indexOnPageControl:Int {
        
        let page = scrollDirrection == .horizontal ?
            Int(collectionView.contentOffset.x / collectionView.bounds.size.width + 0.5) :
            Int(collectionView.contentOffset.y / collectionView.bounds.size.height + 0.5)
        let count = titles.count
        
        if page == 0 { //最左边
            return count - 2
        }else if page == count - 1 { //最右边
            return 0
        }else{
            return page - 1
        }
    }
    
    ///
    
    /// 本地图片推荐初始化方法
    /// - Parameters:
    ///   - frame: 布局frame
    ///   - images: 图片数据源
    ///   - delegate: 代理
    ///   - placeholderImage: 占位图
    init(frame: CGRect, images:[String]? = nil, delegate:JJCycleViewDelegate, placeholderImage:UIImage? = nil){
        super.init(frame: frame)
        
        self.delegate = delegate
        imageType = .SYSTOM
        self.placeholderImage = placeholderImage;
        if let systom = images {
            proxy = Proxy(type: .SYSTOM, array: systom)
        }
        setupUI()
    }
    
    /// 网络推荐初始化方法
    init(frame: CGRect, delegate:JJCycleViewDelegate){
        super.init(frame: frame)
        
        self.delegate = delegate
        imageType = .CUSTOM
        setupUI()
    }
    
    /// 初始化
    init(frame: CGRect, type:JJImageType = .SYSTOM, images:[String]? = nil, placeholderImage:UIImage? = nil){
        super.init(frame: frame)
        
        imageType = type
        self.placeholderImage = placeholderImage;
        if let systom = images {
            proxy = Proxy(type: type, array: systom)
        }
        setupUI()
    }
    
    /// 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        // 解决定时器导致的循环引用
        super.willMove(toSuperview: newSuperview)
        // 展现的时候newSuper不为nil，离开的时候newSuper为nil
        guard let _ = newSuperview else {
            invalidateTimer()
            return
        }
    }
    
    
    private func setupUI() {
        addSubview(collectionView)
        setupPageControl()
    }
    
    private func setupCollectionView(){
        
        collectionView.removeFromSuperview()

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = scrollDirrection == .horizontal ? .horizontal:.vertical
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.register(JJCycleCell.classForCoder(), forCellWithReuseIdentifier:cellID)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        addSubview(collectionView)
        collectionView.reloadData()
    }
    
    /// 定时器事件
    @objc private func timerShowNext() {
         
        if collectionView.isDragging {
            return
        }
        if scrollDirrection == .horizontal {
            let targetX = collectionView.contentOffset.x + collectionView.bounds.size.width
            collectionView.setContentOffset(CGPoint(x: targetX, y: 0), animated: true)
        } else {
            let targetY = collectionView.contentOffset.y + collectionView.bounds.size.height
            collectionView.setContentOffset(CGPoint(x: 0, y:targetY), animated: true)
        }
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 根据collectionView的index返回真实的下标index
    private func pageControlIndexWithCurrentCellIndex(_ index:Int) -> Int{
        if let list = imageArray {
            if list.count > 0 {
                if index == 0 {
                    return list.count - 1
                }else if index == list.count + 1 {
                    return 0
                }else{
                    return index - 1
                }
            }
        }
        return 0
    }
    
    //循环显示
    private func cycleScroll() {
        collectionView.layer.borderWidth = 2;
        if scrollDirrection == .horizontal {
            let page = Int(collectionView.contentOffset.x / collectionView.bounds.size.width + 0.5)
            let count = titles.count
            
            if page == 0 { //最左边
                collectionView.contentOffset = CGPoint(x: collectionView.bounds.size.width * CGFloat((count - 2)), y: 0)
                pageControl?.currentPage = count - 2
            }else if page == count - 1 { //最右边
                collectionView.contentOffset = CGPoint(x: collectionView.bounds.size.width, y: 0)
                pageControl?.currentPage = 0
            }else{
                pageControl?.currentPage = page - 1
            }
        } else {
            let page = Int(collectionView.contentOffset.y / collectionView.bounds.size.height + 0.5)
            let count = titles.count
            
            if page == 0 { //最左边
                collectionView.contentOffset = CGPoint(x: 0, y: collectionView.bounds.size.height * CGFloat((count - 2)))
            }else if page == count - 1 { //最右边
                collectionView.contentOffset = CGPoint(x: 0, y: collectionView.bounds.size.height)
            }
        }
    }
        
    /// 滚动到某一个item
    /// - Parameter index: 下标
    func scrollToItem(index: Int) {
        
        if isAutoScroll {
            invalidateTimer()
        }
        if imageArray?.count == 0 {
            return
        }
        if scrollDirrection == .horizontal {
            collectionView.contentOffset = CGPoint(x: collectionView.bounds.size.width * CGFloat(index + 1) , y: 0)
            pageControl?.currentPage = index
        }else{
            collectionView.contentOffset = CGPoint(x: collectionView.bounds.size.height * CGFloat(index + 1) , y: 0)
        }
        
        if isAutoScroll {
            setupTimer()
        }
    }
    
    /// 刷新数据
    func reloadData() {
        
        setupPageControl()
        if scrollDirrection == .horizontal {
            pageControl?.numberOfPages = imageArray?.count ?? 0
        }
        collectionView.reloadData()
        
        invalidateTimer()
        if isAutoScroll == true {
            setupTimer()
        }
        scrollToItem(index: 0)
    }
        
    deinit {
        print("JJCycleView 页面销毁")
    }
}

extension JJCycleView {

    fileprivate func setupPageControl(){
        pageControl?.removeFromSuperview()
        pageControl = nil
        if scrollDirrection == .horizontal , showPageControl == true, hidesPageControlForSinglePage == false{
            if pageControlFrame == nil {
                pageControlFrame = CGRect(x: 0, y: self.bounds.height - 20, width: self.bounds.width, height: 20)
            }
            pageControl = JJPageControl(frame: pageControlFrame!)
            pageControl?.isHidesForSinglePage = true
            pageControl?.currentColor = self.pageControlCurrentColor
            pageControl?.otherColor = self.pageControlOtherColor
            pageControl?.currentBkImage = self.pageControlCurrentBkImage
            pageControl?.otherBkImage = self.pageControlOtherBkImage
            pageControl?.pointCornerRadius = self.pointCornerRadius
            pageControl?.currentPointSize = CGSize(width: 6, height: 12)
            pageControl?.otherPointSize = CGSize(width: 10, height: 6)
            pageControl?.pageAliment = self.pageControlAliment
            pageControl?.isUserInteractionEnabled = true
            pageControl?.controlSpacing = pageControlPointSpace
            pageControl?.leftAndRightSpacing = self.pageControlLeftAndRightSpacing
            pageControl?.isCanClickPoint = self.isCanClickPageControlPoint
            pageControl?.numberOfPages = imageArray?.count ?? 0
            pageControl?.currentLayerBorderWidth = self.pageControlCurrentLayerBorderWidth ?? 1
            pageControl?.otherLayerBorderWidth = self.pageControlOtherLayerBorderWidth ?? 1
            pageControl?.currentLayerBorderColor = self.pageControlCurrentLayerBorderColor
            pageControl?.otherLayerBorderColor = self.pageControlOtherLayerBorderColor
            
            addSubview(pageControl!)
        }
    }
}

extension JJCycleView {
     
    func setupTimer() {
        timer = Timer(timeInterval: autoScrollInterval, target: self, selector: #selector(timerShowNext), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutoScroll == true{
            setupTimer()
        }
    }
    //手动拖拽结束
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.cycleViewDidScroll?(to: indexOnPageControl, cycleView: self)
        cycleScroll()
        //拖拽操作后3s继续轮播
        if isAutoScroll {
            timer?.fireDate = Date(timeIntervalSinceNow: autoScrollInterval)
        }
    }
    
    //自动轮播结束
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        cycleScroll()
        delegate?.cycleViewDidScroll?(to: indexOnPageControl, cycleView: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        pageControl?.currentPage = indexOnPageControl
    }
    
    
}

extension JJCycleView : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if imageType == .CUSTOM {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
            
            delegate?.setupCustomView?(cycleView: self, cell: cell, index: pageControlIndexWithCurrentCellIndex(indexPath.item))
            let className: AnyClass? = delegate?.customCollectionViewCellClassNameForCycleView?(cycleView: self)
            let nib = delegate?.customCollectionViewCellNibForCycleScrollView?(cycleView: self)
            
            assert((className != nil || nib != nil), "There is no agent that implements the custom cell")
            return cell
           
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! JJCycleCell
            let index = pageControlIndexWithCurrentCellIndex(indexPath.item)
            
            delegate?.setupCustomView?(cycleView: self, cell: cell, index: index)
            cell.imgSource = proxy[index]
            if let descTextArray = descTextArray {
                if descTextArray.count > index {
                    cell.descText = descTextArray[index]
                }
                
                if let imageModel = imageContentModel {
                    cell.imageContentModel = imageModel
                }
                if let font = descLabelFont {
                    cell.descLabelFont = font
                }
                if let color = descLabelTextColor {
                    cell.descLabelTextColor = color
                }
                
                if let lblHeight = descLabelHeight {
                    cell.descLabelHeight = lblHeight
                }
                if let textAlignment = descLabelTextAlignment {
                    cell.descLabelTextAlignment = textAlignment
                }
                if let bottomColor = bottomViewBackgroundColor {
                    cell.bottomViewBackgroundColor = bottomColor
                }
                if let _ = placeholderImage {
                    cell.placeholderImage = placeholderImage
                }
            }
            
            cell.descText = titles[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cycleViewDidSelect?(at: indexOnPageControl, cycleView: self)
    }
    
}
