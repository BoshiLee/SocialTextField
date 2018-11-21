//
//  ViewController.swift
//  SocialTextField
//
//  Created by Boshi Li on 2018/11/19.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate, Mentionable {

    @IBOutlet weak var socialTextView: SocialTextView! {
        didSet {
            let activeFont = UIFont.boldSystemFont(ofSize: 14.0)
            self.socialTextView.regularFont = activeFont
            self.socialTextView.delegate = self
            
            self.socialTextView.hashtagColor = .tagBlue
            self.socialTextView.hashtagFont = activeFont
            self.socialTextView.URLColor = .textBlack
            self.socialTextView.URLUnderLineStyle = .single
            self.socialTextView.URLFont = activeFont
            self.socialTextView.mentionColor = .tagBlue
            self.socialTextView.mentionFont = activeFont
            self.socialTextView.socialDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup popover
        let popoverSize = CGSize(width: self.view.bounds.width * 0.8 , height: 180.0)
        self.socialTextView.setupPopoverMentionView(from: self, withSize: popoverSize )
    }


    func textViewDidChange(_ textView: UITextView) {
        self.socialTextView.setContent(textView.text, mentions: [])
        
    }
    
}

extension ViewController: SocialTextViewDelegate {
    func shouldPresentMentionView(_ mentionViewController: MentionsTableViewController) {
        self.present(mentionViewController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
}

