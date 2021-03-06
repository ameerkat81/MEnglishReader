//
//  Tools.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/10.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit


// textView内容String的拓展
extension String {
    func matchedStrsNSRange(toMatchStr: String) -> [NSRange] {
        var selfStr = self as NSString
        var withStr = Array(repeating: "X", count: (toMatchStr as NSString).length).joined(separator: "") //辅助字符串
        if toMatchStr == withStr { withStr = withStr.lowercased() } //临时处理辅助字符串差错
        var allRange = [NSRange]()
        while selfStr.range(of: toMatchStr).location != NSNotFound {
            let range = selfStr.range(of: toMatchStr)
            allRange.append(range)
            selfStr = selfStr.replacingCharacters(in: range, with: withStr) as NSString
        }
        return allRange
    }
}

extension String.CharacterView._Element {
    func isEnglishLetter() -> Bool{
        let str = String(self)
        for char in str.utf8 {
            if (char > 64 && char < 91) || (char > 96 && char < 123) {
                return true
            }
        }
        return false
    }
}

extension CGContext {
    func convertCoordinateSystem(view: UIView){
        let transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: view.bounds.size.height)
        self.concatenate(transform)
    }
}
