//
//  MArticleListTVC.swift
//  MEnglishReader
//
//  Created by 耿雪萌 on 2017/3/9.
//  Copyright © 2017年 ameerkat. All rights reserved.
//

import UIKit


/// 文章列表
class MArticleListTVC: UITableViewController {
    private var articleItemList: [MArticleItem]?
    
    var loadMoreEnable = true   // 防止重复加载
    
    lazy var loadMoreView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.tableView.contentSize.height, width: self.tableView.bounds.size.width, height: CGFloat(LOADMOREVIEW_HEIGHT)))
        
        // 添加菊花
        let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityViewIndicator.startAnimating()
        view.addSubview(activityViewIndicator)
        
        activityViewIndicator.snp.makeConstraints { (make) in
            make.height.width.equalTo(view.snp.height).multipliedBy(0.5)
            make.center.equalTo(view)
        }
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        refreshArticles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        self.navigationItem.title = "新概念四"
        
        // cell 高度自适应
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(MArticleCell.self, forCellReuseIdentifier: NSStringFromClass(MArticleCell.self))
        
        // 添加刷新控制器
        self.refreshControl =  UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.refreshArticles), for: .valueChanged)
    }
    
    // MARK: - refresh & load data
    func refreshArticles() {
        MDBHelper.sharedDBHelper.selectArticleBy(idRange: [ARTICLE_START_ID,ITEM_AMOUT_OF_ARTICLE_REQUEST]) { articles in
            articleItemList = articles
            refreshControl?.endRefreshing()
            tableView.reloadData()
        }
    }
    
    func loadMoreArticles() {
        MDBHelper.sharedDBHelper.selectArticleBy(idRange: [articleItemList!.count + 1,articleItemList!.count + ITEM_AMOUT_OF_ARTICLE_REQUEST]) { articles in
            articleItemList = articleItemList! + articles
            loadMoreView.removeFromSuperview()
            tableView.reloadData()
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let didScrolledUp =  scrollView.contentSize.height <= 0.0 || scrollView.contentOffset.y + scrollView.contentInset.top <= 0.0 ? false : true
        // 上拉到底部
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
            if loadMoreEnable == true && didScrolledUp == true{
                tableView.refreshControl?.endRefreshing()
                tableView.tableFooterView?.addSubview(loadMoreView)
                loadMoreArticles()
            }
        }
    }

    // MARK: - Table view data source, delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return articleItemList != nil ? articleItemList!.count : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(TABLEVIEW_HEADER_HEIGHT)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(MArticleCell.self), for: indexPath) as! MArticleCell
        
        if let items = articleItemList {
            let item = items[indexPath.section]
            cell.article = item
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let articleDetailVC = MArticleReadTVC()
        articleDetailVC.articleItem = articleItemList![indexPath.section]
        
        navigationController?.pushViewController(articleDetailVC, animated: true)
    }

}
