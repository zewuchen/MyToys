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
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var foto: UIImageView!
    
    @IBOutlet weak var card: UIView! {
        didSet {
            card.layer.cornerRadius = 13
            card.layer.borderWidth = 1
            card.layer.borderColor = #colorLiteral(red: 0.4748159051, green: 0.75166291, blue: 0.9633973241, alpha: 1)
        
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
