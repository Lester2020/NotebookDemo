//
//  ViewController.swift
//  YZNoteBookDemo
//
//  Created by Lester 's Mac on 2021/9/7.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var cardListView: YZNoteCardListView = {
        let view = YZNoteCardListView.init(frame: view.bounds)
        return view
    }()

    private var dataArray = [YZCard]()
    
    private let data = [
        ["note" : "射雕英雄传", "colorStr" : "D9D9D9"],
        ["note" : "神雕侠侣", "colorStr" : "BAE7FF"],
        ["note" : "天龙八部", "colorStr" : "D3F261"],
        ["note" : "鹿鼎记", "colorStr" : "B7EB8F"],
        ["note" : "笑傲江湖", "colorStr" : "FFEADB"],
        ["note" : "侠客行", "colorStr" : "ADC6FF"],
        ["note" : "多情剑客无情剑", "colorStr" : "FFD6E7"],
        ["note" : "小李飞刀", "colorStr" : "B5F5EC"],
        ["note" : "陆小凤传奇", "colorStr" : "E8E8E8"],
        ["note" : "楚留香", "colorStr" : "DAB8F3"],
        ["note" : "七剑下天山", "colorStr" : "B5F5EC"],
        ["note" : "白发魔女传", "colorStr" : "D9F7BE"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(cardListView)
        
        for dict in data {
            let model = YZCard.init(note: dict["note"]!, colorStr: dict["colorStr"]!)
            dataArray.append(model)
        }
        
        cardListView.list = dataArray
    }

    

}

