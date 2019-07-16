//
//  CardToysTableViewCell.swift
//  MyToys
//
//  Created by Zewu Chen on 15/07/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//

import UIKit

class CardToysTableViewCell: UITableViewCell {
    
    @IBOutlet weak var txtName: UILabel!
    
    @IBOutlet weak var card: UIView! {
        didSet {
            card.layer.cornerRadius = 13
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
