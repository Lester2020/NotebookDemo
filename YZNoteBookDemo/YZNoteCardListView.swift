//
//  YZNoteCardListView.swift
//  YZNoteBookDemo
//
//  Created by Lester 's Mac on 2021/9/7.
//

import UIKit

class YZNoteCardListView: UIView {

    private let angles = [(-Double.pi/36), (Double.pi/36), (-Double.pi/18), (Double.pi/18), (-Double.pi/12), (Double.pi/12)]
    private var reusePool = YZCardViewReusePool.init()
    private let cardWH: CGFloat = 185
    /// 第一层卡片数量
    private let firstCount = 8
    /// 最小x
    private let minOriginX: CGFloat = -16
    /// 最大x
    private let maxOriginX: CGFloat = (UIScreen.main.bounds.width / 2.0)
    /// 最小y
    private let minOriginY: CGFloat = 20
    /// 最大y
    private let maxOriginY = UIScreen.main.bounds.height - 44 - UIApplication.shared.statusBarFrame.height
    /// 记录卡片的形变
    private var lastTransform: CGAffineTransform!
    /// 点击手势回调
    typealias YZCardTapAction = (_ view: YZNoteCardView) -> (Void)
    var tapAction: YZCardTapAction?
     
    
    var list: [YZCard]? {
        didSet {
            setUpCardView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCardView() {
        for view in subviews {
            view.isHidden = true
        }
        reusePool.resetReusePool()
        
        guard let list = list else { return }
        
        layoutIfNeeded()
        
        let midOriginX: CGFloat = (UIScreen.main.bounds.width - cardWH) / 2
        let midOriginY: CGFloat = (maxOriginY - minOriginY) / 2
        let marginX = (maxOriginX - minOriginX + cardWH) / (CGFloat(firstCount) / 2)
        let marginY = (maxOriginY - minOriginY + cardWH) / CGFloat(firstCount)
        
        for i in 0..<list.count {
            var originX: CGFloat = 0
            var originY: CGFloat = 0
            let angle = CGFloat(angles[Int.random(in: 0..<angles.count)])
            
            if i == list.count - 1 {
                originX = midOriginX
                originY = midOriginY
                
            } else if i < 8 {
                if i % 2 == 0 {
                    originX = minOriginX
                } else {
                    originX = maxOriginX
                }
                originY = minOriginY + CGFloat(i / 2) * marginY * 2.0
                
            } else {
                originX = minOriginX + CGFloat((Int(arc4random()) % (firstCount / 2 + 1))) * marginX
                originY = minOriginY + CGFloat((Int(arc4random()) % (firstCount + 1))) * marginY
            }
            
            var cardView = reusePool.dequeueReusableCommentCardView()
            if cardView == nil {
                cardView = YZNoteCardView.init()
                reusePool.addUsingView(cardView)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
                cardView?.addGestureRecognizer(tap)
                
                let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
                cardView?.addGestureRecognizer(pan)
            }
            
            cardView?.frame = CGRect(x: originX, y: originY, width: cardWH, height: cardWH)
            cardView?.isHidden = false
            cardView?.transform = CGAffineTransform(rotationAngle: angle)
            addSubview(cardView!)
            cardView?.model = list[i]
        }
    }
    
    
    @objc private func tapAction(_ tap: UITapGestureRecognizer) {
        if let tapAction = tapAction,
            let cardView = tap.view as? YZNoteCardView {
            tapAction(cardView)
        }
    }
    
    @objc private func panAction(_ pan: UIPanGestureRecognizer) {
        let point = pan.translation(in: pan.view)
        let velocity = pan.velocity(in: pan.view)
        let cardView = pan.view as! YZNoteCardView
        var rect = cardView.frame
        
        switch pan.state {
        case .began:
            self.bringSubviewToFront(cardView)
            lastTransform = cardView.transform
            UIView.animate(withDuration: 0.15) {
                cardView.transform = .identity
            }
            
        case .changed:
            var cardCenterX = cardView.center.x + point.x
            
            if cardCenterX < minOriginX + rect.width / 2 {
                cardCenterX = minOriginX + rect.width / 2
            }
            
            if cardCenterX > maxOriginX + rect.width / 2 {
                cardCenterX = maxOriginX + rect.width / 2
            }
            
            var cardCenterY = cardView.center.y + point.y
            
            if cardCenterY < minOriginY + rect.height / 2 {
                cardCenterY = minOriginY + rect.height / 2
            }
            
            if cardCenterY > maxOriginY + rect.height / 2 {
                cardCenterY = maxOriginY + rect.height / 2
            }
            
            cardView.center = CGPoint(x: cardCenterX, y: cardCenterY)
            pan.setTranslation(.zero, in: cardView)
            
        case .ended, .failed, .cancelled:
            if abs(velocity.x) > 400 || abs(velocity.y) > 400 {//滑动速度大于400移除
                if abs(velocity.x) > abs(velocity.y) {//水平滑动
                    if velocity.x > 0 {
                        rect.origin.x = UIScreen.main.bounds.width + rect.width / 2
                    } else {
                        rect.origin.x = -rect.width
                    }
                    
                } else {//上下滑动
                    if velocity.y > 0 {
                        rect.origin.y = UIScreen.main.bounds.height + rect.height / 2
                    } else {
                        rect.origin.y = -(rect.height + self.frame.minY)
                    }
                }
             
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    cardView.frame = rect
                    
                }) { (_) in
                    cardView.isHidden = true
                    cardView.removeFromSuperview()
                    self.reusePool.removeUsingView(cardView)
                }
                
            } else {
                UIView.animate(withDuration: 0.15) {
                    cardView.transform = self.lastTransform
                }
            }
        
        default:
            break
        }
        
    }

}
