//
//  MSliderView.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/11.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit

class MSliderView: UIView {
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 6
        slider.isContinuous = false
        slider.minimumTrackTintColor = MAIN_COLOR

        return slider
    }()
    
    func setUpUI() {
        self.backgroundColor = .white
        
        self.addSubview(slider)
        
        slider.snp.makeConstraints{ (make) in
            make.center.equalTo(self)
            make.left.equalTo(SLIDER_MARGING)
            make.right.equalTo(-SLIDER_MARGING)
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
    
