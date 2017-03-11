//
//  MDBHelper.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/8.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit
import SQLite.Swift
import PKHUD

class MDBHelper {
    static let sharedDBHelper = MDBHelper()
    
    private init() {}
    
    func selectAllArticle(completed: (_ articles: [MArticleItem])->()) {
        guard MDBManager.sharedDBManager.dbConnection != nil else{
            return
        }
        
        do {
            var existArticles = [MArticleItem]()
            
            let query = "SELECT ID, TITLE, CONTENT FROM ARTICLE"
            for article in try MDBManager.sharedDBManager.dbConnection!.prepare(query) {
                let item = MArticleItem(element: article)
                
                if item != nil {
                    existArticles.append(item!)
                }
            }
            
            completed(existArticles)
        } catch _ {
            HUD.flash(HUDContentType.label(DATA_BASE_QUERY_FAULTS_TIPS), delay: 1.0)
        }
    }
    
    
    /// 根据id范围查找文章条目
    ///
    /// - Parameters:
    ///   - idRange: 包含两个数字的数组，分别为最小，最大id
    ///   - completed: 完成处理
    func selectArticleBy(idRange: [Int], completed: (_ articles: [MArticleItem])->()) {
        guard MDBManager.sharedDBManager.dbConnection != nil else{
            return
        }
        
        do {
            var existArticles = [MArticleItem]()
            let query = "SELECT ID, TITLE, CHINESETITLE, ENGLISHCONTENT, CHINESECONTENT FROM ARTICLE WHERE ID >='\(idRange[0])' AND ID <='\(idRange[1])' ORDER BY ID ASC"
            
            for article in try MDBManager.sharedDBManager.dbConnection!.prepare(query) {
                let item = MArticleItem(element: article)
                
                if item != nil {
                    existArticles.append(item!)
                }
            }
            
            completed(existArticles)
        } catch _ {
            HUD.flash(HUDContentType.label(DATA_BASE_QUERY_FAULTS_TIPS), delay: 1.0)
        }
    }
    
    func selectAllNCE4Words(completed: (_ words: [MNCE4Words])->()) {
        guard MDBManager.sharedDBManager.dbConnection != nil else{
            return
        }
        
        do {
            var words = [MNCE4Words]()
            
            let query = "SELECT LEVEL, WORD FROM NCE4WORDS"
            for word in try MDBManager.sharedDBManager.dbConnection!.prepare(query) {
                let item = MNCE4Words(element: word)
                
                if item != nil {
                    words.append(item!)
                }
            }
            
            completed(words)
        } catch _ {
            HUD.flash(HUDContentType.label(DATA_BASE_NCE4WORDS_QUERY_FAULTS), delay: 1.0)
        }
    }
    
    /// 查找指定单词
    func selectWordby(word:String, completed: (_ words: [MNCE4Words])->()) {
        guard MDBManager.sharedDBManager.dbConnection != nil else{
            return
        }
        
        do {
            var words = [MNCE4Words]()
            
            let query = "SELECT LEVEL, WORD FROM NCE4WORDS WHERE WORD == '\(word)'"
            
            for word in try MDBManager.sharedDBManager.dbConnection!.prepare(query) {
                let item = MNCE4Words(element: word)
                
                if item != nil {
                    words.append(item!)
                }
            }
            
            completed(words)
        } catch _ {
            HUD.flash(HUDContentType.label(DATA_BASE_NCE4WORDS_QUERY_FAULTS), delay: 1.0)
        }
    }
}


