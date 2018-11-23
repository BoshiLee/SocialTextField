//
//  MentionsTableViewController.swift
//  SocialTextField
//
//  Created by Boshi Li on 2018/11/20.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import UIKit

final class MentionsTableViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var viewModel: MentionsViewModel = MentionsViewModel(presenter: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.viewModel
        tableView.estimatedSectionHeaderHeight = 0
    }
    
    func searchMentions(by keyword: String) {
        self.viewModel.searchMentions(by: keyword)
    }
    
}

extension MentionsTableViewController: MentionsPresentable {
    
    func didGetMentions() {
        self.tableView.reloadData()
    }
}
