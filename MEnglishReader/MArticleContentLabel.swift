//
//  MArticleContentLabel.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/10.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit

class MArticleContentLabel: UILabel {
    
    var turnOnWordFilter = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var attributeWordLevel: NWCE4WordsLevel = .five {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var highlightWordsLoaction = [CGPoint]() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var mCTFrame: CTFrame?
    
    var allowSelectWord = true
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.convertCoordinateSystem(view: self)
        
        let mutablePath = UIBezierPath(rect: rect)
        let mutableAttributeString =  NSMutableAttributedString(string: self.text!)
        mutableAttributeString.addAttribute(NSFontAttributeName, value: ARLTICLE_CONTENT_FONT, range: NSMakeRange(0, mutableAttributeString.length))
        
        // 文本排版格式
        let style = NSMutableParagraphStyle()
        style.lineSpacing = LINE_SPACING
        style.alignment = .justified
        mutableAttributeString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, mutableAttributeString.length))
        
        // 过滤加下划线
        if(turnOnWordFilter) {
            for word in arributeWords {
                let allMatchedWordsRange = mutableAttributeString.string.matchedStrsNSRange(toMatchStr: word.word!)
                allMatchedWordsRange.forEach {
                    // 检查是否是单个单词
                    let startIndex = $0.location
                    let endIndex = $0.location + $0.length
                    let characters = Array(self.text!.characters)
                    
                    if characters[startIndex-1] == " " && characters[endIndex+1] == " " {
                    mutableAttributeString.addAttributes([NSFontAttributeName:ARLTICLE_CONTENT_FONT,NSUnderlineStyleAttributeName: 1], range: $0)
                    }
                }
            }
        }
        
        // 高亮
        if highlightWordsLoaction.count > 0 && mCTFrame != nil{
            let touchPoint = highlightWordsLoaction.first
            let touchWordIndex = indexOf(point: touchPoint!)
            let rangeIndex = getRangeOfWordAt(index: touchWordIndex,wordsString: self.text!)
            let range = rangeIndex[0] == 0 ? NSMakeRange(rangeIndex[0], rangeIndex[1] - rangeIndex[0]) : NSMakeRange(rangeIndex[0] + 1, rangeIndex[1] - rangeIndex[0] - 1)
            if range.length > 0 {
                mutableAttributeString.addAttributes([NSBackgroundColorAttributeName: MAIN_COLOR, NSForegroundColorAttributeName: HIGHT_LIGHT_TEXT_COLOR],range:range)
            }
            highlightWordsLoaction.removeLast()
            allowSelectWord = true
        }
        
        let framesetter = CTFramesetterCreateWithAttributedString(mutableAttributeString)
        mCTFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mutableAttributeString.length), mutablePath.cgPath, nil)
        CTFrameDraw(mCTFrame!, context!)
    }
    
}


// MARK: - drawRect Helper
extension MArticleContentLabel {
    func indexOf(point: CGPoint) -> CFIndex{
        let reversedPoint = CGPoint(x: point.x, y: self.bounds.maxY - point.y)
        
        let lines = CTFrameGetLines(mCTFrame!) as NSArray
        
        var originsArray = [CGPoint] (repeating: .zero, count: lines.count)
        CTFrameGetLineOrigins(mCTFrame!, CFRangeMake(0, lines.count), &originsArray)
        
        for i in 0..<lines.count {
            if(reversedPoint.y > originsArray[i].y) {
                let line = lines.object(at: i) as! CTLine
                return CTLineGetStringIndexForPosition(line, reversedPoint)
            }
        }
        
        return 0
    }
    
    func getRangeOfWordAt(index: Int, wordsString:String) -> [Int]{
        let characters = Array(wordsString.characters)
        var startIndex = index
        var endIndex = index
        
        if index > characters.count - 1 {
            return [0,0]
        }
        
        while characters[startIndex] != " " && characters[startIndex] != "," && characters[startIndex] != "." && startIndex > 0{
            startIndex -= 1
            if startIndex < 1 {
                break
            }
        }
        while characters[endIndex] != " " && characters[endIndex] != "," && characters[endIndex] != "." && endIndex < characters.count - 1{
            endIndex += 1
            if startIndex > characters.count - 1 {
                break
            }
        }
        
        let startIn = wordsString.index(wordsString.startIndex, offsetBy: startIndex + 1)
        let endIn = wordsString.index(wordsString.startIndex, offsetBy: endIndex - 1)
        if startIn < endIn {
            let substring = wordsString[startIn...endIn]
            // 弹出单词详情窗口通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WordViewShouldShowNotification"), object: self, userInfo: ["Word": substring])
        }
        
        return [startIndex,endIndex]
    }
}

// MARK: - 点击
extension MArticleContentLabel {
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            if self.allowSelectWord {
                self.allowSelectWord = false
                self.highlightWordsLoaction.append(point)
            }
        }
    }
}

extension MArticleContentLabel {
    var arributeWords: [MNCE4Words] {
        get {
            return NCE4WordsMannager.sharedNCE4WordsMannager.getNCE4WordsFrom(wordsString: self.text!, level: self.attributeWordLevel)
        }
    }
}
