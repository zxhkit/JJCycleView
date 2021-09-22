//
//  JJTestCollectionViewCell.swift
//  SwiftTools
//
//  Created by 播呗网络 on 2021/9/1.
//  Copyright © 2021 xuanhe. All rights reserved.
//

import UIKit

class JJTestCollectionViewCell: UICollectionViewCell {
    
    var name: String? {
        //didSet 作用更大 能够获取新值和旧值
        //在视图绑定模型数据的时候会使用didSet
        //属性设置检查器
        didSet {
            titleLabel.text = name
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "AmericanTypewriter", size: 50)
        lbl.textColor = UIColor.red
        //设置
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.frame = self.bounds
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
