//
//  MNce4Words.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/8.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit
import SQLite.Swift

enum NWCE4WordsLevel:Int64 {
    case zero = 0, one, two, three, four, five, six, unknown
}

class MNCE4Words {
    var level: NWCE4WordsLevel?
    var word: String?
    
    init?(element:  Statement.Element) {
        if let unwrapped = element[0] as? Int64 {
            level = NWCE4WordsLevel(rawValue: unwrapped)
        }else {
            return nil
        }
        if let unwrapped = element[1] as? String {
            word = unwrapped
        }else {
            return nil
        }
    }
}
