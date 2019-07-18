//
//  CameraViewController.swift
//  MyToys
//
//  Created by Zewu Chen on 18/07/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAddFoto(_ sender: Any) {
        Camera().selecionadorImagem(self){ imagem in
            self.image.image = imagem
            
        }
    }

}
