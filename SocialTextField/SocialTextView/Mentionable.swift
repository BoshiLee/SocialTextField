//
//  Mentionable.swift
//  SocialTextField
//
//  Created by Boshi Li on 2018/11/22.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import UIKit

class MentionWindow: UIWindow {
    
    lazy var mentionViewModel: MentionsViewModel = MentionsViewModel(presenter: self)
    var tableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTableView() {
        self.tableView = UITableView()
        self.tableView.separatorStyle = .none
        self.tableView.dataSource = self.mentionViewModel
        self.tableView.delegate = self.mentionViewModel
        self.tableView.frame = self.bounds
        self.addSubview(tableView)

    }
    
    func searchMention(by keyword: String) {
        self.mentionViewModel.searchMentions(by: keyword)
    }
}

extension MentionWindow: MentionsPresentable {
    func didGetMentions() {
        self.tableView.reloadData()
    }
    
}
