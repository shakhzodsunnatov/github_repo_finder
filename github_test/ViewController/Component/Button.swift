//
//  Button.swift
//  github_test
//
//  Created by Shokhzod on 08/07/22.
//

import UIKit

class Button: UIButton {
    var backgroundColorHighlighted: UIColor?
    var backgroundColorDisabled: UIColor?
    var backgroundColorSelected: UIColor?
    
    var titleColorSelected: UIColor? {
        didSet {
            self.setTitleColor(titleColorSelected, for: .selected)
        }
    }
    
    var widthAdditional: CGFloat = 0
    var heightAdditional: CGFloat = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setup()
    }
    
    init(title: String = "", color: UIColor? = nil, borderColor: UIColor? = nil) {
        self.init()
        
        defer {
            self.title = title
            self.color = color
            self.borderColor = borderColor
        }
    }
    
    private func setup() {
        self.backgroundColor = UIColor.clear
        self.titleColor = UIColor.white;
    }
    
    var actionClosure: () -> (Void) = {} {
        didSet {
            self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        }
    }
    
    @objc func buttonTapped() {
        self.actionClosure()
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? backgroundColorSelected : color
            
            self.isUserInteractionEnabled = !isSelected
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if (color == nil && borderColor == nil) {
                self.imageView?.alpha = isHighlighted ? 0.5 : 1
            } else {
                if (isSelected == false) {
                    backgroundColor = isHighlighted ? backgroundColorHighlighted : color
                }
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? color : backgroundColorDisabled
        }
    }
    
    var titleColor: UIColor! {
        didSet {
            self.setTitleColor(titleColor, for: .normal)
            if (titleColor != nil) {
                self.setTitleColor(titleColor.withAlphaComponent(0.5), for: .highlighted)
            }
            self.setTitleColor(UIColor.white, for: .disabled)
        }
    }
    
    var color: UIColor? {
        didSet {
            if (color != nil) {
                self.backgroundColor = color
                self.titleColor = UIColor.white
                
//                backgroundColorHighlighted = color?.withAlphaComponent(0.5)
//                backgroundColorDisabled = UIColor(red: 224, green: 224, blue: 224)
//
//                backgroundColorSelected = .anorColor
            }
        }
    }
    
    var borderColor: UIColor? {
        didSet {
            if (borderColor != nil) {
                self.titleColor = borderColor
                
                backgroundColorHighlighted = (color != nil ? color : borderColor)?.withAlphaComponent(0.5)
                
                self.layer.borderWidth = 1.0
                self.layer.borderColor = borderColor?.cgColor
            }
        }
    }
    
    var fontSize: CGFloat = 15 {
        didSet {
            self.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeOld = super.sizeThatFits(size)
        
        if (widthAdditional > 0 || heightAdditional > 0) {
            sizeOld.width += widthAdditional*2
            sizeOld.height += heightAdditional*2
        } else if (image != nil) {
            sizeOld.width += 10
        } else if (sizeOld.width < titleWidth + 20) {
            sizeOld.width += 20
        }
        
        return sizeOld
    }
    
    enum ImagePosition {
        case left
        case right
    }
    
    var imagePosition = ImagePosition.left
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.imageRect(forContentRect: contentRect)
        
        if (self.contentHorizontalAlignment == .center) {
            if (imagePosition == .right) {
                rect.origin.x = contentRect.width - rect.width - padding
            } else {
                if (image != nil && !title.isEmpty) {
                    rect.origin.x -= 5
                    
                    if (imageWidthDelta > 0) {
                        rect.size.width -= imageWidthDelta
                        rect.origin.x += imageWidthDelta/2 + 5
                    }
                    
                    if (imageHeightDelta > 0) {
                        rect.size.height -= imageHeightDelta
                        rect.origin.y += imageHeightDelta/2
                    }
                }
            }
        }
        
        return rect
    }
    
    var titleWidth: CGFloat = 0
    
    var imageHeightDelta: CGFloat = 0
    var imageWidthDelta: CGFloat = 0
    
    var padding: CGFloat = 0
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.titleRect(forContentRect: contentRect)
        
        if (imagePosition == .right) {
            rect.origin.x -= imageView?.frame.size.width ?? 0
        } else {
            if (image != nil) {
                rect.origin.x += 5
            }
        }
        
        titleWidth = rect.size.width
        
        return rect
    }
}

extension UIButton {
    private struct AssociatedKeys {
        static var title = "title"
        static var font = "font"
        static var imageName = "imageName"
        static var image = "image"
    }

    var title: String! {
        get {
            guard let title = objc_getAssociatedObject(self, &AssociatedKeys.title) as? String else {
                return ""
            }

            return title
        }

        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.title, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.setTitle(value, for: .normal)
        }
    }
    
    var font: UIFont! {
        get {
            guard let font = objc_getAssociatedObject(self, &AssociatedKeys.font) as? UIFont else {
                return UIFont.systemFont(ofSize: 15, weight: .thin)
            }

            return font
        }

        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.font, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.titleLabel?.font = value
        }
    }
    
    var image: UIImage? {
        get {
            guard let image = objc_getAssociatedObject(self, &AssociatedKeys.image) as? UIImage else {
                return nil
            }

            return image
        }

        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.image, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            self.setImage(value, for: .normal)
        }
    }
    
    var imageName: String! {
        get {
            guard let imageName = objc_getAssociatedObject(self, &AssociatedKeys.imageName) as? String else {
                return ""
            }

            return imageName
        }

        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.imageName, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            self.image = UIImage(named: value)
        }
    }
    
    func addTarget(_ target: Any?, action: Selector) {
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}
