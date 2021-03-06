//
//  MConstParameter.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/8.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit

let DATA_BASE_CONNECTION_FAULTS_TIPS = "资料库连接失败"
let DATA_BASE_DATA_COPY_FAULTS_TIPS = "数据库拷贝到沙盒失败"
let DATA_BASE_QUERY_FAULTS_TIPS = "资料加载失败，刷新一下吧～"
let DATA_BASE_NCE4WORDS_QUERY_FAULTS = "过滤单词加载失败，重试一下吧～"

let SCREEN_WDITH: CGFloat = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.size.height
let NAVI_HEIGHT: CGFloat = 64
let MAIN_COLOR = UIColor(colorLiteralRed: 41/255.0, green: 143/255.0, blue: 113/255.0, alpha: 1.0)
//let MAIN_COLOR = UIColor(red: 41/255.0, green: 143/255.0, blue:113/255.0, alpha: 1.0)

// slider UI
let SLIDER_HIEGHT: CGFloat = 70
let SLIDER_MARGING: CGFloat = 8
let MENU_FONT_SIZE: CGFloat = 15

// MArticleListTVC UI
let LOADMOREVIEW_HEIGHT: CGFloat = 60
let TABLEVIEW_HEADER_HEIGHT: CGFloat = 10

// MArticleCell UI
let TITLE_FONT = UIFont(name: "Baskerville", size: 22)
let CONTENT_FONT = UIFont(name: "Baskerville", size: 19)
let M_ARTICLECELL_MARGIN = 8
let M_ARTICLECELL_SPACING = 4

// DATA
let ITEM_AMOUT_OF_ARTICLE_REQUEST = 7
let ARTICLE_START_ID = 1
let REMIND_OF_NO_SUCH_WORD_IN_DB = "资料库里没有这个单词哦～"

// MArticleTitleCell
let ENGLISH_TITLE_FONT = UIFont(name: "Baskerville", size: 25)
let CHINESE_TITLE_FONT = UIFont(name: "Baskerville", size: 18)
let MARTICLE_TITLE_CELL_HEIGHT: CGFloat = 60

// MArticleContentCell
let CONTENT_TEXTVIEW_MARGIN: CGFloat = 8

// MArticleContentLabel
let HIGHT_LIGHT_TEXT_COLOR = UIColor.white
let HIGHT_LIGHT_SHADOW_COLOR = UIColor.darkGray

// String
let ARLTICLE_CONTENT_FONT = UIFont(name: "Baskerville", size: 23)
let ARLTICLE_CONTENT_NORMAL_COLOR = UIColor.black
let ARLTICLE_CONTENT_HIGHLIGHT_COLOR = UIColor.white
let ARLTICLE_CONTENT_HIGHLIGHT_SHADOW = UIColor.darkGray

// 动画
let AnimateDuration:TimeInterval = 0.25

// 文字排版
let FIRST_LINE_HEAD_INDENT:CGFloat = 20
let LINE_SPACING:CGFloat = 10
let TAIL_INDENT: CGFloat = 10

// MWordFilterModal
let WORDFILTER_VIEW_WIDTH: CGFloat = 200 + 2*WORDFILTER_VIEW_BORDER_WIDTH
let WORDFILTER_VIEW_HEIGHT: CGFloat = WORDFILTER_VIEW_SLIDER_HEIGHT + WORDFILTER_VIEW_SWITCH_HEIGHT + WORDFILTER_VIEW_TRIGON_HEIGHT + 2*WORDFILTER_VIEW_BORDER_WIDTH + 1// 40*2 + 10
let WORDFILTER_VIEW_TRIGON_HEIGHT: CGFloat = 8
let WORDFILTER_VIEW_TRIGON_WDITH: CGFloat = 10
let WORDFILTER_VIEW_CORNERRADIUS: CGFloat = 10
let WORDFILTER_VIEW_TRAILING: CGFloat = 8
let WORDFILTER_VIEW_SLIDER_HEIGHT: CGFloat = 50
let WORDFILTER_VIEW_SWITCH_HEIGHT: CGFloat = 50
let WORDFILTER_VIEW_BORDER_WIDTH: CGFloat = 3

// MWordInfoModal
let INFOMODAL_VIEW_MARGIN: CGFloat = 30
let TITLE_LABEL_HEIGHT:CGFloat = 40
let TITLE_LABEL_WDITH:CGFloat = 250
let INFOMODAL_MARGIN:CGFloat = 30
let LEVEL_LABEL_WDITH:CGFloat = 100
let LEVEL_LABEL_HEIGHT:CGFloat = 100
let LEVEL_LABEL_MARGIN:CGFloat = 8
let CLOSE_BTN_WIDTH: CGFloat = 50
let INFOMODAL_TITLE_FONT = UIFont(name: "Baskerville-Bold", size: 25)
let INFOMODAL_LEVEL_FONT = UIFont(name: "Baskerville-Bold", size: 50)
