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
    
    func getCursorPosition() -> Int {
        if let selectedRange = self.selectedTextRange {
            return self.offset(from: self.startPosition, to: selectedRange.start)
        } else {
            return 0
        }
    }
    
    func setCusor(to arbitraryValue: Int) {
        // only if there is a currently selected range
        if let selectedRange = self.selectedTextRange {
            
            // and only if the new position is valid
            if let newPosition = self.position(from: selectedRange.start, offset: arbitraryValue) {
                // set the new position
                self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
            }
        }
    }
    
    func getCurrentTypingLocation() -> Int {
        return getCursorPosition() - 1 < 0 ? 0 : getCursorPosition() - 1
    }
    
    func getCurrentTypingCharacter() -> String? {
        guard let current = text.character(at: self.getCurrentTypingLocation() ) else { return nil }
        return String(current)
    }
    
    func isCurrentTyping(is string: String) -> Bool {
        guard let current = self.getCurrentTypingCharacter(), current == string else { return false }
        return true
    }

}

