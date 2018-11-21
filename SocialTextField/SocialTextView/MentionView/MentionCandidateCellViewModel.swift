//
//  MentionCandidateCellViewModel.swift
//  SocialTextField
//
//  Created by Boshi Li on 2018/11/20.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import UIKit

class MentionCandidateCellViewModel {
    
    let photoImageURL: URL
    let nickName: String
    
    init(photoImageURL: URL, nickName: String) {
        self.photoImageURL = photoImageURL
        self.nickName = nickName
    }
    
    func dequeue(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MentionCandidateCell", for: indexPath) as? MentionCandidateCell else { return UITableViewCell() }
        cell.configure(withViewModel: self)
        return cell
    }
    
}
