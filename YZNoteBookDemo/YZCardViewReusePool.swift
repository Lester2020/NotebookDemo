//
//  YZCardViewReusePool.swift
//  YZNoteBookDemo
//
//  Created by Lester 's Mac on 2021/9/7.
//

import UIKit

class YZCardViewReusePool: NSObject {

    private var waitUsedPool = NSMutableSet.init()
    private var usingPool = NSMutableSet.init()
    
    func dequeueReusableCommentCardView() -> YZNoteCardView? {
        guard let view = waitUsedPool.anyObject() as? YZNoteCardView else {
            return nil
        }
        
        waitUsedPool.remove(view)
        usingPool.add(view)
        return view
    }
    
    func addUsingView(_ view: YZNoteCardView?) {
        guard let cardView = view else {
            return
        }
        
        usingPool.add(cardView)
    }
    
    func removeUsingView(_ view: YZNoteCardView?) {
        guard let cardView = view else {
            return
        }
        
        usingPool.remove(cardView)
        waitUsedPool.add(cardView)
    }
    
    func resetReusePool() {
        for _ in 0..<usingPool.count {
            if let view = usingPool.anyObject() {
                usingPool.remove(view)
                waitUsedPool.add(view)
            }
        }
    }
}
