//
//  TextViewHelper.swift
//  SocialTextField
//
//  Created by Boshi Li on 2018/11/21.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import UIKit

extension SocialTextView {
    var startPosition: UITextPosition {
        return self.beginningOfDocument
    }
    
    var endPosition: UITextPosition {
        return self.endOfDocument
    }
    
    func getCusorPosition() -> Int {
        if let selectedRange = self.selectedTextRange {
            return self.offset(from: self.startPosition, to: selectedRange.start)
        } else {
            return 0
        }
    }
}
