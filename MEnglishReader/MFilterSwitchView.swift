//
//  MFilterSwitchView.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/11.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit

class MFilterSwitchView: UIView {
    
    lazy var mSwitch: UISwitch = {
        let sw = UISwitch()
        sw.isOn = false
        sw.tintColor = MAIN_COLOR
        sw.onTintColor = MAIN_COLOR
        return sw
    } ()
    
    
    lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: CGFloat(MENU_FONT_SIZE))
        
        return label
    } ()
    
    func setUpUI() {
        self.backgroundColor = .white
        
        self.addSubview(levelLabel)
        self.addSubview(mSwitch)
        
        levelLabel.snp.makeConstraints{ (make) in
            make.top.left.equalTo(SLIDER_MARGING)
            make.bottom.equalTo(-SLIDER_MARGING)
            make.right.equalTo(mSwitch).offset(-SLIDER_MARGING/2)
        }
        
        mSwitch.snp.makeConstraints{ (make) in
            make.top.equalTo(SLIDER_MARGING)
            make.bottom.right.equalTo(-SLIDER_MARGING)
        }
    }
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
