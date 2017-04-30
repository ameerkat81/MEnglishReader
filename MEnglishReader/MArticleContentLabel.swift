//
//  MArticleContentLabel.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/10.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit

class MArticleContentLabel: UILabel, MWordFilterModalDelegate{
    
    var turnOnWordFilter = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var attributeWordLevel: NWCE4WordsLevel = .zero {
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
        if let context = UIGraphicsGetCurrentContext() {
            context.convertCoordinateSystem(view: self)
            
            let mutablePath = UIBezierPath(rect: rect)
            let mutableAttributeString =  NSMutableAttributedString(string: self.text!)
            
            // 文本排版格式
            let style = NSMutableParagraphStyle()
            style.lineSpacing = LINE_SPACING
            style.alignment = .justified
            mutableAttributeString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, mutableAttributeString.length))
            mutableAttributeString.addAttribute(NSFontAttributeName, value: ARLTICLE_CONTENT_FONT, range: NSMakeRange(0, mutableAttributeString.length))
            
            // 过滤加下划线
            if(turnOnWordFilter) {
                for word in arributeWords {
                    let allMatchedWordsRange = mutableAttributeString.string.matchedStrsNSRange(toMatchStr: word.word!)
                    allMatchedWordsRange.forEach {
                        // 检查是否是单个单词
                        let startIndex = $0.location
                        let endIndex = $0.location + $0.length
                        let characters = Array(self.text!.characters)
                        
                        if !characters[startIndex-1].isEnglishLetter() && !characters[endIndex].isEnglishLetter() {
                            mutableAttributeString.addAttributes([
                                NSUnderlineStyleAttributeName: 1], range: $0)
                        }
                    }
                }
            }
            
            // 高亮
            scope: if highlightWordsLoaction.count > 0 && mCTFrame != nil{
                let touchedPoint = highlightWordsLoaction.first!
                let reversedPoint = CGPoint(x: touchedPoint.x, y: self.bounds.maxY - touchedPoint.y)
                let touchedLine = getLineTouchedAt(point: reversedPoint, frame: mCTFrame!)
                let touchedWordIndex = CTLineGetStringIndexForPosition(touchedLine, reversedPoint)
                
                guard let rangeIndex = getRangeOfWordAt(index: touchedWordIndex,wordsString: self.text!) else{ highlightWordsLoaction.removeLast(); break scope }
                
                let range = NSMakeRange(rangeIndex[0], rangeIndex[1] - rangeIndex[0] + 1)
                
                guard let currentRun = getTouchedRunIn(touchedLine: touchedLine, touchedWordIndex: touchedWordIndex, touchedWordRange: range), range.length > 0 else{ highlightWordsLoaction.removeLast(); break scope }
                
                // 高亮文字变色
                mutableAttributeString.addAttributes([NSForegroundColorAttributeName: HIGHT_LIGHT_TEXT_COLOR], range:range)
                
                var ascent: CGFloat = 0
                var descent: CGFloat = 0
                var leading: CGFloat = 0
                CTRunGetTypographicBounds(currentRun, CFRangeMake(0,0), &ascent, &descent, &leading)
                
                let lineOrigin = getTouchedLineOrigins(point: reversedPoint, frame: mCTFrame!)
                let xOffset: CGFloat = CTLineGetOffsetForStringIndex(touchedLine, range.location, nil)
                let xNextOffset:CGFloat = CTLineGetOffsetForStringIndex(touchedLine, range.location+range.length+1, nil)
                let runBounds = CGRect(x: lineOrigin.x+xOffset, y: lineOrigin.y-descent, width: xNextOffset-xOffset-4, height: ascent+descent)
                let path = UIBezierPath(roundedRect: runBounds, cornerRadius: 5)
                
                context.saveGState()
                context.textPosition = CGPoint(x: lineOrigin.x, y: lineOrigin.y)
                MAIN_COLOR.setFill()
                path.fill()
                CTRunDraw(currentRun, context, CFRangeMake(0,0))
                context.restoreGState()
                
                highlightWordsLoaction.removeLast()
                
                // 弹出单词详情窗口通知
                let startIn = self.text!.index(self.text!.startIndex, offsetBy: rangeIndex[0])
                let endIn = self.text!.index(self.text!.startIndex, offsetBy: rangeIndex[1])
                let substring = self.text![startIn...endIn]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WordViewShouldShowNotification"), object: self, userInfo: ["Word": substring])
            }
            
            let framesetter = CTFramesetterCreateWithAttributedString(mutableAttributeString)
            mCTFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mutableAttributeString.length), mutablePath.cgPath, nil)
            CTFrameDraw(mCTFrame!, context)
            
            allowSelectWord = true
        }
    }
    
}


// MARK: - drawRect Helper
extension MArticleContentLabel {
    func getTouchedRunIn(touchedLine: CTLine, touchedWordIndex: CFIndex, touchedWordRange: NSRange) ->CTRun?{
        let runs = CTLineGetGlyphRuns(touchedLine) as NSArray
        var currentRun: CTRun?
        for i in 0..<runs.count {
            let run = runs[i] as! CTRun
            let runRange = CTRunGetStringRange(run)
            if (touchedWordIndex <= runRange.location + runRange.length - 1) && (touchedWordIndex >= touchedWordRange.location) {
                currentRun = run
                break
            }
        }
        return currentRun ?? nil
    }
    
    func getLineTouchedAt(point: CGPoint, frame: CTFrame) -> CTLine{
        let lines = CTFrameGetLines(mCTFrame!) as NSArray
        
        var originsArray = [CGPoint] (repeating: .zero, count: lines.count)
        CTFrameGetLineOrigins(mCTFrame!, CFRangeMake(0, lines.count), &originsArray)
        
        var line: CTLine!
        for i in 0..<lines.count {
            if(point.y > originsArray[i].y) {
                line = lines.object(at: i) as! CTLine
                break
            }
        }
        
        return line
    }
    
    
    func getTouchedLineOrigins(point: CGPoint, frame: CTFrame) ->CGPoint{
        let lines = CTFrameGetLines(mCTFrame!) as NSArray
        
        var originsArray = [CGPoint] (repeating: .zero, count: lines.count)
        CTFrameGetLineOrigins(mCTFrame!, CFRangeMake(0, lines.count), &originsArray)
        
        var origin: CGPoint!
        for i in 0..<lines.count {
            if(point.y > originsArray[i].y) {
                origin = originsArray[i]
                break
            }
        }
        
        return origin
    }
    
    func getRangeOfWordAt(index: Int, wordsString:String) -> [Int]?{
        let characters = Array(wordsString.characters)
        var startIndex = index
        var endIndex = index
        
        if index > characters.count - 1 {
            return [0,0]
        }
        
        while characters[startIndex].isEnglishLetter() && startIndex > -1{
            startIndex -= 1
            if startIndex < 0 {
                break
            }
        }
        while characters[endIndex].isEnglishLetter() && endIndex < characters.count {
            endIndex += 1
            if startIndex > characters.count - 1 {
                break
            }
        }
        
        if startIndex+1 < endIndex-1 {
            return [startIndex+1, endIndex-1]
        }
        
        return nil
    }
}

// MARK: - MWordFilterModalDelegate
extension MArticleContentLabel {
    func filterLevelSliderValueChanged(value: Int) {
        attributeWordLevel = NWCE4WordsLevel(rawValue: Int64(value))!
    }
    
    func filterTurnSwitchValueChanged(isOn: Bool) {
        turnOnWordFilter = isOn
    }
}

// MARK: - 点击事件
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

// MARK: - NCE4Words 数据获取
extension MArticleContentLabel {
    var arributeWords: [MNCE4Words] {
        get {
            let tnp = NCE4WordsMannager.sharedNCE4WordsMannager.getNCE4WordsFrom(wordsString: self.text!, level: self.attributeWordLevel)
            return tnp
        }
    }
}
