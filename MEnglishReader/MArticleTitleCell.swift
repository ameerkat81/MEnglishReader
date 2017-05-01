//
//  MArticleTitleCell.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/10.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit

class MArticleTitleCell: UITableViewCell {
    var article: MArticleItem? {
        didSet{
            englishTitleLabel.text = "Lesson " + String(article!.id!) + ": " + article!.title!
            chineseTitleLabel.text = article!.chineseTitle
        }
    }
    
    // MARK: - SubViews
    /// 文章标题
    lazy var englishTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = ENGLISH_TITLE_FONT
        titleLabel.numberOfLines = 2
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    
    lazy var chineseTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = CHINESE_TITLE_FONT
        titleLabel.textColor = UIColor.lightGray
        return titleLabel
    }()
    
    // MARK: - UI
    private func setupUI() {
        
        contentView.addSubview(englishTitleLabel)
        contentView.addSubview(chineseTitleLabel)
        
        contentView.snp.makeConstraints{ (make) in
            make.left.top.right.bottom.equalTo(self)
        }
        
        englishTitleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.contentView).offset(M_ARTICLECELL_MARGIN)
            make.right.equalTo(self.contentView).offset(-M_ARTICLECELL_MARGIN)
            make.bottom.equalTo(chineseTitleLabel.snp.top).offset(-M_ARTICLECELL_MARGIN/2)
        }
        
        chineseTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(M_ARTICLECELL_MARGIN)
            make.right.bottom.equalTo(self.contentView).offset(-M_ARTICLECELL_MARGIN)
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
