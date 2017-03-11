//
//  MArticleItem.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/8.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit
import SQLite.Swift

class MArticleItem {
    var id: Int64?
    var title: String?
    var chineseTitle: String?
    var englishContent: String?
    var chineseContent: String?
    
    init?(element:  Statement.Element) {
        if let unwrapped = element[0] as? Int64 {
            id = unwrapped
        }else {
            return nil
        }
        if let unwrapped = element[1] as? String {
            title = unwrapped
        }else {
            return nil
        }
        if let unwrapped = element[2] as? String {
            chineseTitle = unwrapped
        }else {
            return nil
        }
        if let unwrapped = element[3] as? String {
            englishContent = unwrapped
        }else {
            return nil
        }
        if let unwrapped = element[4] as? String {
            chineseContent = unwrapped
        }else {
            return nil
        }
    }
}
