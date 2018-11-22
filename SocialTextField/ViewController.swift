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

    }


    func textViewDidChange(_ textView: UITextView) {
        self.socialTextView.setContent(mentions: [])
    }
    
}

extension ViewController: SocialTextViewDelegate {
    func shouldDismissMentionView() {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func shouldPresentMentionView(_ mentionViewController: MentionsTableViewController) {
        self.present(mentionViewController, animated: true, completion: nil)
    }
    
    
}

