//
//  CardToysCollectionViewCell.swift
//  MyToys
//
//  Created by Zewu Chen on 21/01/20.
//  Copyright © 2020 Zewu Chen. All rights reserved.
//

import UIKit

class CardToysCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var view: UIView! {
        didSet {
            view.layer.cornerRadius = 16
            //card.layer.borderWidth = 1
            //card.layer.borderColor = .none
            view.layer.backgroundColor = #colorLiteral(red: 0.7333333333, green: 0.8196078431, blue: 0.9176470588, alpha: 1)
        }
    }
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var checkmarkLabel: UILabel! {
        didSet {
            checkmarkLabel.layer.cornerRadius = 12
        }
    }
    
    var isInEditingMode: Bool = false {
        didSet {
            checkmarkLabel.isHidden = !isInEditingMode
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isInEditingMode {
                checkmarkLabel.text = isSelected ? "✓" : ""
                checkmarkLabel.backgroundColor = isSelected ? #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1) : UIColor.clear
            }
        }
    }
    
}
