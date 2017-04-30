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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showWordDetail(notification:)), name: NSNotification.Name(rawValue: "WordViewShouldShowNotification"), object: nil)
    }
}


// MARK: - HudView提醒
extension MArticleReadTVC {
    func showWordDetail(notification: Notification) {
        let userInfo = notification.userInfo as! [String : AnyObject]
        let word = userInfo["Word"] as! String
        
        MDBHelper.sharedDBHelper.selectWordby(word: word) { words in
            if words.count > 0 {
                HUD.flash(HUDContentType.label("\(word)属于Level \(words[0].level!.rawValue)"), delay: 2.0)
            }else {
                HUD.flash(HUDContentType.label(REMIND_OF_NO_SUCH_WORD_IN_DB), delay: 0.8)
            }
        }
    }
}

// MARK: - wordFilterView
extension MArticleReadTVC {
    func changeMWordFilterModal() {
        self.wordFilterModalView.isHidden = !self.wordFilterModalView.isHidden
    }
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
