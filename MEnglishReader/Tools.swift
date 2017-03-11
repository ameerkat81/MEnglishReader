//
//  Tools.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/10.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit


// MARK: - 字符串匹配
enum MTextAttributeStyle {
    case underline
    case none
}

// textView内容String的拓展
extension String {
    func matchedStrsNSRange(toMatchStr: String) -> [NSRange] {
        var selfStr = self as NSString
        var withStr = Array(repeating: "X", count: (toMatchStr as NSString).length).joined(separator: "") //辅助字符串
        if toMatchStr == withStr { withStr = withStr.lowercased() } //临时处理辅助字符串差错
        var allRange = [NSRange]()
        while selfStr.range(of: toMatchStr).location != NSNotFound {
            let range = selfStr.range(of: toMatchStr)
            allRange.append(NSRange(location: range.location,length: range.length))
            selfStr = selfStr.replacingCharacters(in: NSMakeRange(range.location, range.length), with: withStr) as NSString
        }
        return allRange
    }
}

extension CGContext {
    func convertCoordinateSystem(view: UIView){
        let transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: view.bounds.size.height)
        self.concatenate(transform)
    }
}
