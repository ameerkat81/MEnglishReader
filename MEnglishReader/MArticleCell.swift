//
//  MArticleCell.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/9.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit
import SnapKit

class MArticleCell: UITableViewCell {
    var article: MArticleItem? {
        didSet{
            titleLabel.text = "Lesson " + String(article!.id!) + ": " + article!.title!
            contentLabel.text = article!.englishContent!
        }
    }
    
    // MARK: - SubViews
    /// 文章标题
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = TITLE_FONT
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.black
        return titleLabel
    }()
    
    /// 文章内容
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = CONTENT_FONT
        contentLabel.textColor = UIColor.lightGray
        return contentLabel
    }()
    
    // MARK: - UI
    private func setupUI() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        
        contentView.snp.makeConstraints{ (make) in
            make.left.top.right.bottom.equalTo(self)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(M_ARTICLECELL_MARGIN)
            make.right.equalTo(self.contentView).offset(-M_ARTICLECELL_MARGIN)
            make.bottom.equalTo(contentLabel.snp.top)
        }
        
        contentLabel.numberOfLines = 3
        contentLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.bottom.equalTo(self.contentView).offset(-M_ARTICLECELL_MARGIN)
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
