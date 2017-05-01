//
//  ArticleDetailVC.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/10.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit
import PKHUD


/// 文章详情
class MArticleReadTVC: UITableViewController, UITextViewDelegate, UIGestureRecognizerDelegate {
    var articleItem: MArticleItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        
        contentCell.contentLabel.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        wordInfoModal.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var  wordInfoModal: MWordInfoModal = {
        let modal = MWordInfoModal(frame: CGRect(x: 30, y: SCREEN_HEIGHT + 16, width: SCREEN_WDITH - 60
            , height: SCREEN_HEIGHT / 2.0))
        UIApplication.shared.keyWindow?.addSubview(modal)
        return modal
    }()
    
    lazy var titleCell: MArticleTitleCell = {
        let cell = MArticleTitleCell()
        cell.article = self.articleItem
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var contentCell: MArticleContentCell = {
        let cell = MArticleContentCell()
        cell.article = self.articleItem
        cell.contentLabel.isUserInteractionEnabled = true
        cell.separatorInset = UIEdgeInsets(top: 0, left: 1000, bottom: 0, right: 0)
        cell.selectionStyle = .none
        return cell
    } ()
    
    lazy var wordFilterModalView: MWordFilterModal = {
        let rightBarButtonItemFrame = (self.navigationItem.rightBarButtonItem!.value(forKey: "view") as! UIView).frame
        let trigonPeak = CGPoint(x: rightBarButtonItemFrame.origin.x + rightBarButtonItemFrame.width/2, y: NAVI_HEIGHT)
        let rectangleFrame = CGRect(x: SCREEN_WDITH - WORDFILTER_VIEW_WIDTH - WORDFILTER_VIEW_TRAILING, y:
            NAVI_HEIGHT, width: WORDFILTER_VIEW_WIDTH, height: WORDFILTER_VIEW_HEIGHT)
        let modalFrame = MWordFilterModalFrame(rectangleFrame: rectangleFrame, trigonPeak: trigonPeak, trigonWidth: WORDFILTER_VIEW_TRIGON_WDITH, trigonHeight: WORDFILTER_VIEW_TRIGON_HEIGHT)
        let modalView = MWordFilterModal(modalFrame: modalFrame)
    
        modalView.delegate = self.contentCell.contentLabel
        modalView.backgroundColor = MAIN_COLOR
        modalView.isHidden = true
        
        UIApplication.shared.keyWindow?.addSubview(modalView)
        return modalView
    }()
    
    private func setupUI() {
        self.navigationItem.title = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "单词过滤", style: .plain, target: self, action: #selector(self.changeMWordFilterModal))
    }
}


// MARK: - MArticleContentLabelDelegate
extension MArticleReadTVC: MArticleContentLabelDelegate{
    func mArticleContentLabelWillHightLight(word: String) {
        MDBHelper.sharedDBHelper.selectWordby(word: word) { words in
            if words.count > 0 {
                wordInfoModal.wordText = word
                wordInfoModal.wordLevel = words[0].level!
            }else {
                wordInfoModal.wordText = word
                wordInfoModal.wordLevel = .unknown
            }
            if !wordInfoModal.isShowed { wordInfoModal.show() }
        }
    }
    
    func mArticleContentLabelTouchedAtBlank() {
        wordInfoModal.dismiss()
    }
}



// MARK: - wordFilterView
extension MArticleReadTVC {
    func changeMWordFilterModal() {
        self.wordFilterModalView.isHidden = !self.wordFilterModalView.isHidden
    }
}

// MARK: - scrollViewDelegate
extension MArticleReadTVC {
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let yOffset = scrollView.contentOffset.y
//        if wordInfoModal.isShowed{
//            wordInfoModal.frame = CGRect(x: wordInfoModal.frame.minX, y: SCREEN_HEIGHT/2 + yOffset + NAVI_HEIGHT, width: wordInfoModal.frame.width, height: wordInfoModal.frame.height)
//        }else{
//            wordInfoModal.frame = CGRect(x: wordInfoModal.frame.minX, y: SCREEN_HEIGHT + yOffset + NAVI_HEIGHT, width: wordInfoModal.frame.width, height: wordInfoModal.frame.height)
//        }
//    }
}

// MARK: - UITableViewDataSource, delegate
extension MArticleReadTVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            let labelSize = contentCell.contentLabel.sizeThatFits(CGSize(width: 200, height: CGFloat(MAXFLOAT)))
            return labelSize.height + 1
        }
        
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return titleCell
        }else {
            return contentCell
        }
    }
}
