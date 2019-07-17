//
//  OptionTableViewCell.swift
//  MyToys
//
//  Created by Zewu Chen on 16/07/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblTextoTamanho: UILabel!
    @IBOutlet weak var lblTextoFaixaEtaria: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
