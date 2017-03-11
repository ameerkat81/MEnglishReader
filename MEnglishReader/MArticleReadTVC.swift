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
    
    lazy var bottomSlider: MSliderView = {
        let slider = MSliderView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WDITH, height: SLIDER_HIEGHT))
        self.contentCell.addSubview(slider)
        slider.isHidden = true
        slider.slider.value = Float(self.contentCell.contentLabel.attributeWordLevel.rawValue)
        return slider
    } ()
    
    lazy var bottomSwitch: MFilterSwitchView = {
        let mSwitch = MFilterSwitchView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WDITH, height: SLIDER_HIEGHT))
        self.contentCell.addSubview(mSwitch)
        mSwitch.isHidden = true
        mSwitch.levelLabel.text = "单词过滤等级:\(self.contentCell.contentLabel.attributeWordLevel.rawValue)"
        return mSwitch
    } ()
    
    private func setupUI() {
        self.navigationItem.title = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "单词过滤", style: .plain, target: self, action: #selector(self.showFilterView))
        
        bottomSlider.slider.addTarget(self, action: #selector(self.sliderChanged(_:)), for: UIControlEvents.valueChanged)
        bottomSwitch.mSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: UIControlEvents.valueChanged)
        
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
                HUD.flash(HUDContentType.label(REMIND_OF_NO_SUCH_WORD_IN_DB), delay: 1.0)
            }
        }
    }
}


// MARK: - bottomView
extension MArticleReadTVC {
    func showFilterView() {
        if bottomSwitch.isHidden == false {
            setupBottomView(bottomSwitch, viewHeight: 60, hidden: true, animated: true, completion: nil)
            setupBottomView(bottomSlider, viewHeight: 60, hidden: true, animated: true, completion: nil)
        }else {
            setupBottomView(bottomSwitch, viewHeight: 60, hidden: false, animated: true, completion: nil)
            
            if bottomSwitch.mSwitch.isOn  {
                setupBottomView(bottomSlider, viewHeight: 60, hidden: false, animated: true, completion: nil)
            }
        }
    }
    
    func switchChanged(_ mSwitch: UISwitch) {
        contentCell.contentLabel.turnOnWordFilter = mSwitch.isOn
        
        if !mSwitch.isOn {
            setupBottomView(bottomSlider, viewHeight: 60, hidden: true, animated: true, completion: nil)
        }else {
            setupBottomView(bottomSlider, viewHeight: 60, hidden: false, animated: true, completion: nil)
        }
    }
    
    func sliderChanged(_ slider: UISlider) {
        let value = slider.value
        let intValue = Int(value + 0.5)
        slider.value = Float(intValue)
        
        bottomSwitch.levelLabel.text = "单词过滤等级：\(intValue)"
        
        contentCell.contentLabel.attributeWordLevel = NWCE4WordsLevel(rawValue: Int64(intValue))!
    }
    
    func setupBottomView(_ view:UIView,viewHeight:CGFloat,hidden:Bool,animated:Bool,completion:(() -> Void)?) {
        if view.isHidden == hidden {
            return
        }
        let animateDuration = animated ? AnimateDuration : 0
        let viewH:CGFloat = viewHeight
        
        if hidden {
            UIView.animate(withDuration: animateDuration, animations: { ()->() in
                view.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WDITH, height: viewH)
            }, completion: { (isOK) in
                view.isHidden = hidden
                
                if completion != nil {completion!()}
            })
        }else{
            view.isHidden = hidden
            let addtionViewH = NSStringFromClass(view.classForCoder) == "MEnglishReader.MSliderView" ? SLIDER_HIEGHT - 10 : 0
            
            UIView.animate(withDuration: animateDuration, animations: { ()->() in
                view.frame = CGRect(x: 0, y: SCREEN_HEIGHT - viewH - NAVI_HEIGHT - self.titleCell.frame.height - addtionViewH, width: SCREEN_WDITH, height: viewH)
                print(view.frame)
            }, completion: { (isOK) in
                if completion != nil {completion!()}
            })
        }
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
            contentCell.setNeedsLayout()
            contentCell.layoutIfNeeded()
            
            let labelSize = contentCell.contentLabel.sizeThatFits(CGSize(width: SCREEN_WDITH,height: CGFloat(MAXFLOAT)))
            let attributes = [NSFontAttributeName: contentCell.contentLabel.font]
            let size = contentCell.contentLabel.text!.boundingRect(with: labelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attributes, context: nil)
            return  size.height + 1
        }
        
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return titleCell
        }else {
            return contentCell
        }
    }
}
