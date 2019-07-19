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
    var foto:UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAddFoto(_ sender: Any) {
        Camera().selecionadorImagem(self){ imagem in
            self.image.image = imagem
            self.foto = imagem
        }
    }
    
    @IBAction func btnSalvar(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true) Dá pop em apenas uma tela
        Toy.shared.saveFoto(imagem: foto!)
        Toy.shared.save()
        self.navigationController?.popToRootViewController(animated: true) //Dá pop até o RootViewController
    }

}
