//
//  MWordInfoModal.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/5/1.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit

protocol MWordInfoModalDelegate {
    func MWordInfoModalWillHide()
}

class MWordInfoModal: UIView {
    
    var wordText: String = "" {
        didSet { titleLabel.text = "\(wordText)  level" }
    }
    
    var wordLevel: NWCE4WordsLevel = .unknown {
        didSet { levelLabel.text = wordLevel != .unknown ? String(wordLevel.rawValue) : "?" }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: (SCREEN_WDITH - INFOMODAL_MARGIN*2) / 2.0 - TITLE_LABEL_WDITH/2, y: 0, width: TITLE_LABEL_WDITH, height: TITLE_LABEL_HEIGHT))
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        label.text = self.wordText
        label.font = INFOMODAL_TITLE_FONT
        label.addCharactersSpacing(3, text: self.wordText)
        label.layer.addLateralBorder(UIRectEdge.bottom, color: UIColor.black, thickness: 1)
        self.addSubview(label)
        return label
    }()
    
    lazy var levelLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: (SCREEN_WDITH - INFOMODAL_MARGIN*2) / 2.0 - LEVEL_LABEL_WDITH/2, y: TITLE_LABEL_HEIGHT + LEVEL_LABEL_MARGIN, width: LEVEL_LABEL_WDITH, height: LEVEL_LABEL_HEIGHT))
        label.text = self.wordLevel != .unknown ? String(self.wordLevel.rawValue) : "?"
        label.font = INFOMODAL_LEVEL_FONT
        label.textAlignment = .center
        self.addSubview(label)
        return label
    }()
    
    lazy var closeBtn: MWordInfoModalCloseBtn = {
        let button = MWordInfoModalCloseBtn(frame: CGRect(x: (SCREEN_WDITH - INFOMODAL_MARGIN*2) / 2.0 - CLOSE_BTN_WIDTH/2, y: TITLE_LABEL_HEIGHT + LEVEL_LABEL_MARGIN*2 + LEVEL_LABEL_HEIGHT, width: CLOSE_BTN_WIDTH, height: CLOSE_BTN_WIDTH))
        self.addSubview(button)
        return button
    }()
    
    var isShowed: Bool = false
    var initialPoint: CGPoint?
    var delegate: MWordInfoModalDelegate?
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor ( red: 0.2608, green: 0.8168, blue: 0.8177, alpha: 1.0 ).cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor ( red: 0.6699, green: 0.6941, blue: 0.7486, alpha: 1.0 ).cgColor
        self.layer.shadowRadius = 10
        
        closeBtn.addTarget(self, action: #selector(MWordInfoModal.dismiss), for: UIControlEvents.touchUpInside)
        
        let downGesture = UIPanGestureRecognizer(target: self, action: #selector(MWordInfoModal.swipedDown))
        self.addGestureRecognizer(downGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        if !isShowed{
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.frame = CGRect(x: 30, y: (SCREEN_HEIGHT / 3.0)*2, width: SCREEN_WDITH - 60, height: SCREEN_HEIGHT / 3.0)
            }, completion: { (Bool) in
                self.isShowed = true
            })
        }
    }
    
    func dismiss() {
        if isShowed{
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.frame = CGRect(x: 30, y: SCREEN_HEIGHT + 16, width: SCREEN_WDITH - 60, height: SCREEN_HEIGHT / 3.0)
            }, completion: { (Bool) -> Void in
                self.isShowed = false
                self.delegate?.MWordInfoModalWillHide()
            })
        }
    }
    
    func swipedDown(_ sender: UIPanGestureRecognizer) -> Void {

        let translation = sender.translation(in: self)

        if sender.state == UIGestureRecognizerState.began {
            self.initialPoint = self.center
        }

        if let senderView = sender.view {
            if translation.y > 0 {
                senderView.center = CGPoint(x: senderView.center.x, y: senderView.center.y + translation.y)
            }else {
                if senderView.center.y + translation.y > (self.initialPoint?.y)! {
                    senderView.center = CGPoint(x: senderView.center.x, y: senderView.center.y + translation.y)
                }
            }
        }
        sender.setTranslation(CGPoint.zero, in: self)

        if sender.state == UIGestureRecognizerState.ended {
            if (sender.view?.center.y)! - (self.initialPoint?.y)! > CGFloat(100) {
                self.dismiss()
            }else {
                UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    sender.view?.center = self.initialPoint!
                }, completion: nil)
            }
        }
    }
}

extension CALayer {
    
    func addLateralBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer();
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness);
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}

extension UILabel {
    func addCharactersSpacing(_ spacing: CGFloat, text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, text.characters.count))
        self.attributedText = attributedString
    }
    
}
