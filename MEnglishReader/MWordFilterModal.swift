//
//  MWordFilterModal.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/4/29.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit
import QuartzCore

struct MWordFilterModalFrame {
    var rectangleFrame: CGRect
    var trigonPeak: CGPoint
    var trigonWidth: CGFloat
    var trigonHeight: CGFloat
}

protocol MWordFilterModalDelegate {
    func filterLevelSliderValueChanged(value: Int)
    func filterTurnSwitchValueChanged(isOn: Bool)
}

class MWordFilterModal: UIView {
    var mFrame: MWordFilterModalFrame
    
    var delegate: MWordFilterModalDelegate?
    
    lazy var filterTurnSwitch: MFilterSwitchView = {
        let mSwitch = MFilterSwitchView(frame: CGRect(x: WORDFILTER_VIEW_BORDER_WIDTH, y: WORDFILTER_VIEW_TRIGON_HEIGHT + WORDFILTER_VIEW_BORDER_WIDTH, width: WORDFILTER_VIEW_WIDTH - 2*WORDFILTER_VIEW_BORDER_WIDTH, height: WORDFILTER_VIEW_SWITCH_HEIGHT))
        mSwitch.layer.addRoundedCorner(cornerTypes: [.topLeft, .topRight], withRadius: WORDFILTER_VIEW_CORNERRADIUS)
        mSwitch.isHidden = false
        mSwitch.levelLabel.text = "单词过滤等级:!"
        self.addSubview(mSwitch)
        return mSwitch
    } ()
    
    lazy var filterLevelSlider: MSliderView = {
        let slider = MSliderView(frame: CGRect(x: WORDFILTER_VIEW_BORDER_WIDTH, y: WORDFILTER_VIEW_TRIGON_HEIGHT + WORDFILTER_VIEW_SWITCH_HEIGHT + WORDFILTER_VIEW_BORDER_WIDTH + 1, width: WORDFILTER_VIEW_WIDTH - 2*WORDFILTER_VIEW_BORDER_WIDTH, height: WORDFILTER_VIEW_SLIDER_HEIGHT))
        slider.layer.addRoundedCorner(cornerTypes: .bottomLeft, withRadius: WORDFILTER_VIEW_CORNERRADIUS)
        slider.layer.addRoundedCorner(cornerTypes: [.bottomLeft, .bottomRight], withRadius: WORDFILTER_VIEW_CORNERRADIUS)
        slider.isHidden = false
        slider.slider.value = Float(0)
        slider.slider.isEnabled = false
        self.addSubview(slider)
        return slider
    } ()
    
    var mWordFilterModalFrame: MWordFilterModalFrame{
        get{
            return self.mFrame
        }
        set{
            self.mFrame = newValue
            self.layer.mask = makeDialogLayerMask()
        }
    }
    
    
    init(modalFrame: MWordFilterModalFrame){
        mFrame = modalFrame
        
        super.init(frame: modalFrame.rectangleFrame)
        
        mWordFilterModalFrame = modalFrame
        
        filterLevelSlider.slider.addTarget(self, action: #selector(self.sliderChanged(_:)), for: UIControlEvents.valueChanged)
        filterTurnSwitch.mSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 子控件Target
extension MWordFilterModal {
    func switchChanged(_ mSwitch: UISwitch) {
        filterLevelSlider.slider.isEnabled = mSwitch.isOn
        
        delegate?.filterTurnSwitchValueChanged(isOn: mSwitch.isOn)
    }
    
    func sliderChanged(_ slider: UISlider) {
        let value = slider.value
        let intValue = Int(value + 0.5)
        slider.value = Float(intValue)
        
        filterTurnSwitch.levelLabel.text = "单词过滤等级：\(intValue)"
        
        delegate?.filterLevelSliderValueChanged(value: intValue)
    }
}

// MARK: - 事件
extension MWordFilterModal {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !self.isUserInteractionEnabled || self.isHidden { return nil }
        
        for view in self.subviews {
            let convertedPoint = view.convert(point, from: self)
            if let hitTestView = view.hitTest(convertedPoint, with: event) {
                return hitTestView
            }
        }
        
        return self
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self.superview!)
            if !self.mFrame.rectangleFrame.contains(point) {
                self.isHidden = true
            }
        }
    }
}

// MARK: - 绘制
extension MWordFilterModal {
    // MARK: - 绘制对话框边框蒙板
    func makeDialogLayerMask() -> CAShapeLayer {
        let viewWidth = self.mFrame.rectangleFrame.width
        let viewHeight = mFrame.rectangleFrame.height
        let trigonWidth = mFrame.trigonWidth
        let trigonHeight = mFrame.trigonHeight
        let rightSpace: CGFloat = SCREEN_WDITH - mFrame.trigonPeak.x - trigonWidth/2    // 三角右下角距离矩形边界距离
        
        let point0 = CGPoint(x: viewWidth - rightSpace - trigonWidth, y: trigonHeight)
        let point1 = CGPoint(x: viewWidth - rightSpace - trigonWidth/2, y: 0)
        let point2 = CGPoint(x: viewWidth - rightSpace, y: trigonHeight)
        let point3 = CGPoint(x: viewWidth - WORDFILTER_VIEW_CORNERRADIUS, y: trigonHeight)
        let rightUpCornerCenter = CGPoint(x: viewWidth - WORDFILTER_VIEW_CORNERRADIUS, y: trigonHeight + WORDFILTER_VIEW_CORNERRADIUS)
        let point4 = CGPoint(x: viewWidth, y: viewHeight - WORDFILTER_VIEW_CORNERRADIUS)
        let rightDownCornerCenter = CGPoint(x: viewWidth - WORDFILTER_VIEW_CORNERRADIUS, y: viewHeight - WORDFILTER_VIEW_CORNERRADIUS)
        let point5 = CGPoint(x: WORDFILTER_VIEW_CORNERRADIUS, y: viewHeight)
        let leftDownCornerCenter = CGPoint(x: WORDFILTER_VIEW_CORNERRADIUS, y: viewHeight - WORDFILTER_VIEW_CORNERRADIUS)
        let point6 = CGPoint(x: 0, y: viewHeight + WORDFILTER_VIEW_CORNERRADIUS)
        let leftUpCornerCenter = CGPoint(x: WORDFILTER_VIEW_CORNERRADIUS, y: trigonHeight + WORDFILTER_VIEW_CORNERRADIUS)
        
        let path = UIBezierPath()
        path.move(to: point0)
        path.addLine(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addArc(withCenter: rightUpCornerCenter, radius: WORDFILTER_VIEW_CORNERRADIUS, startAngle: CGFloat.pi*3/2, endAngle: 0, clockwise: true)
        path.addLine(to: point4)
        path.addArc(withCenter: rightDownCornerCenter, radius: WORDFILTER_VIEW_CORNERRADIUS, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
        path.addLine(to: point5)
        path.addArc(withCenter: leftDownCornerCenter, radius: WORDFILTER_VIEW_CORNERRADIUS, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
        path.addLine(to: point6)
        path.addArc(withCenter: leftUpCornerCenter, radius: WORDFILTER_VIEW_CORNERRADIUS, startAngle: CGFloat.pi, endAngle: CGFloat.pi*3/2, clockwise: true)
        path.addLine(to: point0)
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        return layer
    }
}

extension CALayer {
    /// 部分添加圆角
    func addRoundedCorner(cornerTypes: UIRectCorner, withRadius: CGFloat){
        let roundedPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornerTypes, cornerRadii: CGSize(width: withRadius, height: withRadius))
        let shape = CAShapeLayer()
        shape.path = roundedPath.cgPath
        
        self.mask = shape
    }
}
