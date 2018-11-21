//
//  MentionsTableViewController.swift
//  SocialTextField
//
//  Created by Boshi Li on 2018/11/20.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import UIKit

final class MentionsTableViewController: UITableViewController {
    
    private lazy var viewModel: MentionsViewModel = MentionsViewModel(presenter: self)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.viewModel
    }
    
    func searchMentions(by keyword: String) {
        self.viewModel.searchMentions(by: keyword)
    }
    
}

extension MentionsTableViewController: MentionsPresentable, Mentionable {
    
    func didGetMentions() {
        
    }
    
}
