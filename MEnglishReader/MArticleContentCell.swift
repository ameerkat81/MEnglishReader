//
//  MArticleContentCell.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/10.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit

class MArticleContentCell: UITableViewCell {
    var article: MArticleItem? {
        didSet{
            contentLabel.text = article!.englishContent
        }
    }
    
    // MARK: - SubViews
    
    lazy var contentLabel: MArticleContentLabel = {
        let label = MArticleContentLabel()
        label.font = ARLTICLE_CONTENT_FONT
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - UI
    private func setupUI() {
        contentView.addSubview(contentLabel)
        
        contentView.snp.makeConstraints{ (make) in
            make.left.top.equalTo(self).offset(CONTENT_TEXTVIEW_MARGIN)
            make.right.bottom.equalTo(self).offset(-CONTENT_TEXTVIEW_MARGIN)
        }
        
        contentLabel.snp.remakeConstraints { (make) in
            make.left.top.equalTo(self.contentView).offset(CONTENT_TEXTVIEW_MARGIN)
            make.right.bottom.equalTo(self.contentView).offset(-CONTENT_TEXTVIEW_MARGIN)
        }
    }
    
    // MARK: - init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
