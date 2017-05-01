//
//  MWordInfoModalCloseBtn.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/5/1.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit

class MWordInfoModalCloseBtn: UIButton {

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        MAIN_COLOR.setFill()
        path.fill()
        
        let plusMargin: CGFloat = min(bounds.width, bounds.height) * 0.3
        let pointArg = bounds.width/2 - (bounds.width/2-plusMargin)*cos(CGFloat.pi/4)
        let point1S = CGPoint(x: pointArg, y: pointArg)
        let point1E = CGPoint(x: bounds.width - pointArg, y: bounds.width - pointArg)
        let point2S = CGPoint(x: bounds.width - pointArg, y: pointArg)
        let point2E = CGPoint(x: pointArg, y: bounds.width - pointArg)
        let plusPath = UIBezierPath()
        
        plusPath.lineWidth = 3.0

        plusPath.move(to: point1S)
        plusPath.addLine(to: point1E)
        plusPath.move(to: point2S)
        plusPath.addLine(to: point2E)

        UIColor.white.setStroke()
        
        plusPath.stroke()
    }

}
