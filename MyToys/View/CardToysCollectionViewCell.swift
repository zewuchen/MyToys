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
    
    
}
