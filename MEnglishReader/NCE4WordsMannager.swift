//
//  MTextViewDataMannager.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/10.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit

class NCE4WordsMannager {
    static let sharedNCE4WordsMannager = NCE4WordsMannager()
    
    lazy var nce4Words: [MNCE4Words] = {
        var tmpWords = [MNCE4Words]()
        MDBHelper.sharedDBHelper.selectAllNCE4Words { words in
            tmpWords = words
        }
        return tmpWords
    }()
    
    private init() {}
    
    func getNCE4WordsFrom(wordsString:String, level: NWCE4WordsLevel) -> [MNCE4Words]{
        print(level)
        let filteredWords = nce4Words.filter(){
            return $0.level == level
        }
        return filteredWords
    }
}

