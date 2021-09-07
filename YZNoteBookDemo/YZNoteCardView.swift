//
//  YZNoteCardView.swift
//  YZNoteBookDemo
//
//  Created by Lester 's Mac on 2021/9/7.
//

import UIKit

class YZNoteCardView: UIView {

    var contentLabel: UILabel = {
        let label = UILabel.init()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    var model: YZCard? {
        didSet {
            contentLabel.text = model?.note
            backgroundColor = colorWithString(hexString: model?.colorStr ?? "B5F5EC")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentLabel.frame = CGRect(x: 10, y: 10, width: bounds.width - 20, height: bounds.height - 20)
    }
    
    func colorWithString(hexString: String) -> UIColor {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cString.count < 6 {
            return UIColor.black
        }
        
        let index = cString.index(cString.endIndex, offsetBy: -6)
        let subString = cString[index...]
        if cString.hasPrefix("0X") {
            cString = String(subString)
        }
        if cString.hasPrefix("#") {
            cString = String(subString)
        }
        if cString.count != 6 {
            return UIColor.black
        }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
    
}
