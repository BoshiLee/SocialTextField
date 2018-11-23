//
//  SocialTextView.swift
//  SocialTextField
//
//  Created by Boshi Li on 2018/11/20.
//  Copyright © 2018 Boshi Li. All rights reserved.
//

import UIKit

protocol SocialTextViewDelegate: AnyObject {
    var mentionPopoverWindow: MentionWindow? { get set }
    func shouldPresentMentionView()
    func shouldDismissMentionView()
}

extension SocialTextViewDelegate {
    func shouldPresentMentionView() {
        self.mentionPopoverWindow?.isHidden = false
    }
    func shouldDismissMentionView() {
        self.mentionPopoverWindow?.isHidden = true
    }
}

class SocialTextView: UITextView {

    // MARK: - override UILabel properties

    override open var textAlignment: NSTextAlignment {
        didSet { updateTextAttributed(parseText: false)}
    }
    
    // MARK: - Inspectable Properties
    @IBInspectable open var regularFont: UIFont = UIFont.systemFont(ofSize: 17.0) {
        didSet { updateTextAttributed(parseText: false) }
    }
    
    @IBInspectable open var regularColor: UIColor = .black  {
        didSet { updateTextAttributed(parseText: false) }
    }
    
    @IBInspectable open var mentionFont: UIFont?  {
        didSet { updateTextAttributed(parseText: false) }
    }
    
    @IBInspectable open var mentionColor: UIColor = .blue  {
        didSet { updateTextAttributed(parseText: false) }
    }
    
    @IBInspectable open var mentionSelectedColor: UIColor?  {
        didSet { updateTextAttributed(parseText: false) }
    }
    
    @IBInspectable open var mentionUnderLineStyle: NSUnderlineStyle = []  {
        didSet { updateTextAttributed(parseText: false) }
    }
    
    @IBInspectable open var hashtagFont: UIFont?  {
        didSet { updateTextAttributed(parseText: false) }
    }
    
    @IBInspectable open var hashtagColor: UIColor = .blue  {
        didSet { updateTextAttributed(parseText: false) }
    }
    
    @IBInspectable open var hashtagSelectedColor: UIColor?  {
        didSet { updateTextAttributed(parseText: false) }
    }
    
    @IBInspectable open var hashtagUnderLineStyle: NSUnderlineStyle = [] {
        didSet { updateTextAttributed(parseText: false) }
    }
    
    @IBInspectable open var URLColor: UIColor = .blue  {
        didSet { updateTextAttributed(parseText: false) }
    }
    
    @IBInspectable open var URLSelectedColor: UIColor?  {
        didSet { updateTextAttributed(parseText: false) }
    }
    
    @IBInspectable open var URLFont: UIFont?  {
        didSet { updateTextAttributed(parseText: false) }
    }
    
    @IBInspectable open var URLUnderLineStyle: NSUnderlineStyle = [] {
        didSet { updateTextAttributed(parseText: false) }
    }
    
    // MARK: - Private Properties don't open it
    private lazy var cachedSocialElements: [SocialElement] = [SocialElement]()
    private lazy var mentionDict: MentionDict = MentionDict()
    private var selectedElement: SocialElement?
    
    // MARK: - Popover related properties
    private var mentionView: UIView?
    private var mentionTableViewController: MentionsTableViewController?
    private var isPopoverPresenting: Bool = false
    private var lastMentionRange: NSRange?
    
    fileprivate var _customizing: Bool = true

    // MARK: - Public properties
    open var enableType: [SocialType] = [.mention, .hashtag, .url]
    open weak var socialDelegate: SocialTextViewDelegate?
    
    open var originText: String = ""
    open var prensentingText: String = ""
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _customizing = false
        self.keyboardType = .twitter
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        updateTextAttributed()
    }
    
    open func setContent(mentions: [MentionUser]) {
        self.mentionDict.removeAll()
        for mention in mentions {
            mentionDict[mention.account] = mention
        }
        self.originText = self.text

        guard !self.isTypingChineseAlpahbet() else { return }
        self.popoverHandler(text: originText)
        self.updateTextAttributed()
    }
    
    fileprivate func isTypingChineseAlpahbet() -> Bool {
        guard let aString = self.text else { return true }
        let selectedRange: UITextRange? = self.markedTextRange
        // 獲取被選取的文字區域（在打注音時，還沒選字以前注音會被選起來）
        guard selectedRange == nil else { return true}
        guard !aString.isEmpty, aString != "" else {
            self.lastMentionRange = nil
            self.dismissPopover()
            return true
        }
        return false
    }
    
}

// MARK: - Popover Handler
extension SocialTextView {
    
    private func popoverHandler(text: String) {

        if self.isCurrentTyping(is: "@") {
            if let lastMentionLocation = self.lastMentionRange?.location { //判斷是否已有 ＠
                self.lastMentionRange = NSRange(location: lastMentionLocation, length: self.getCurrentTypingLocation())
            } else { // 沒有 ＠ 新增一個 range, 跳 popover
                self.lastMentionRange = NSRange(location: self.getCurrentTypingLocation(), length: 0)
                self.presentPopover()
                self.socialDelegate?.mentionPopoverWindow?.searchMention(by: "@")
            }

        } else if self.isTypingAfterMention() {
            if let lastMentionLocation = self.lastMentionRange?.location {
                let length = self.getCurrentTypingLocation() - lastMentionLocation > 0 ? self.getCurrentTypingLocation() - lastMentionLocation : 0
                self.lastMentionRange = NSRange(location: lastMentionLocation, length: length)
            }
            self.presentPopover()
        } else {
            self.lastMentionRange = nil
            self.dismissPopover()
        }
    }
    
    private func isTypingAfterMention() -> Bool {
        // 確定是否在 mention 後面
        guard let lastMentionRange = self.lastMentionRange else { return false }
        return self.getCurrentTypingLocation() > lastMentionRange.location
    }
    
    private func presentPopover() {
        guard !self.isPopoverPresenting else { return }
        self.socialDelegate?.shouldPresentMentionView()
        self.isPopoverPresenting = true
    }
    
    private func dismissPopover() {
        self.socialDelegate?.shouldDismissMentionView()
        self.isPopoverPresenting = false
    }
    
}


// MARK: - Attributed String Handler
extension SocialTextView {
    
    fileprivate func updateTextAttributed(parseText: Bool = true) {
        // clean up previous active elements
        let mutAttrString = NSMutableAttributedString(string: self.originText)
        if parseText {
            self.clearActiveElements()
            let newString = parseTextAndExtractActiveElements(mutAttrString)
            mutAttrString.mutableString.setString(newString)
        }
        self.addLinkAttribute(mutAttrString, with: self.cachedSocialElements)
        self.text = mutAttrString.string
        self.textStorage.setAttributedString(mutAttrString)
        setNeedsDisplay()
    }
    
    fileprivate func clearActiveElements() {
        self.selectedElement = nil
        self.cachedSocialElements.removeAll()
    }
    
    /// use regex check all link ranges
    fileprivate func parseTextAndExtractActiveElements(_ attrString: NSAttributedString) -> String {
        var textString = attrString.string
        var elements: [SocialElement] = []
        elements.append(contentsOf: ElementBuilder.relpaceMentions(form: &textString, with: self.mentionDict))
        elements.append(contentsOf: ElementBuilder.matches(from: textString, withSocialType: .hashtag))
        elements.append(contentsOf: ElementBuilder.matches(from: textString, withSocialType: .url))
        self.cachedSocialElements = elements
        return textString
    }
    
    fileprivate func removeAllAttribute(_ mutAttrString: NSMutableAttributedString) {
        let range = NSRange(location: 0, length: mutAttrString.length)
        var attributes = [NSAttributedString.Key : Any]()
        
        // 保持原本在 storyboard 的顏色字體設定
        attributes[.font] = self.regularFont
        attributes[.foregroundColor] = self.regularColor
        mutAttrString.setAttributes(attributes, range: range)
    }
    
    fileprivate func addLinkAttribute(_ mutAttrString: NSMutableAttributedString, with elements: [SocialElement]) {
        self.removeAllAttribute(mutAttrString)
        // 針對各個元素的顏色字體設定
        for element in elements {
            switch element.type {
            case .mention:
                let id = element.content
                if let user = self.mentionDict[id], user.shouldActive {
                    mutAttrString.setAttributes(
                        self.createAttributes(with: element.type),
                        range: element.range)
                }
            case .hashtag, .url:
                mutAttrString.setAttributes(
                    self.createAttributes(with: element.type),
                    range: element.range)
            }
        }
    }
    
    fileprivate func createAttributes(with socialType: SocialType) -> [NSAttributedString.Key : Any] {
        var attributes = [NSAttributedString.Key : Any]()
        switch socialType {
        case .mention:
            guard self.enableType.contains(socialType) else { break }
            attributes[.font] = mentionFont ?? font!
            attributes[.foregroundColor] = mentionColor
            attributes[.underlineStyle] = mentionUnderLineStyle.rawValue
        case .hashtag:
            guard self.enableType.contains(socialType) else { break }
            attributes[.font] = hashtagFont ?? font!
            attributes[.foregroundColor] = hashtagColor
            attributes[.underlineStyle] = hashtagUnderLineStyle.rawValue
        case .url:
            guard self.enableType.contains(socialType) else { break }
            attributes[.font] = URLFont ?? font!
            attributes[.foregroundColor] = URLColor
            attributes[.underlineStyle] = URLUnderLineStyle.rawValue
        }
        return attributes
    }
}


