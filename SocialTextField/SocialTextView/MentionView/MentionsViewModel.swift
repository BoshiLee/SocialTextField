//
//  MentionsViewModel.swift
//  SocialTextField
//
//  Created by Boshi Li on 2018/11/20.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import UIKit

protocol MentionsPresentable: AnyObject {
    func didGetMentions()
}

class MentionsViewModel: NSObject {
    
    lazy var cellViewModels = [MentionCandidateCellViewModel]()
    
    weak var presenter: MentionsPresentable!
    
    init(presenter: MentionsPresentable) {
        self.presenter = presenter
        
        super.init()
    }
    
    func searchMentions(by keyword: String) {
        
    }
    
}

extension MentionsViewModel: UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.cellViewModels[indexPath.row].dequeue(tableView, at: indexPath)
        return cell
    }
}
