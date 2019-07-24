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
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    var foto:UIImage? = nil
    var delete:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSave.isEnabled = false

        if let ima = Toy.shared.foto, Toy.shared.edit == true{
            self.image.image = UIImage(contentsOfFile: ima)
            self.foto = UIImage(contentsOfFile: ima)
            self.btnSave.isEnabled = true
        }
    }
    
    @IBAction func btnAddFoto(_ sender: Any) {
        Camera().selecionadorImagem(self){ imagem in
            self.image.image = imagem
            self.foto = imagem
            self.btnSave.isEnabled = true
            
            if let ima = Toy.shared.foto, Toy.shared.edit == true{
                Toy.shared.deleteFoto(fileURL: ima)
                self.delete = true
            }
        }
    }
    
    @IBAction func btnSalvar(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true) Dá pop em apenas uma tela
        if Toy.shared.edit == true, let id = Toy.shared.id{
            if delete == true{
                Toy.shared.saveFoto(imagem: foto!)
            }
            Toy.shared.update(id: id)
        }else{
            Toy.shared.saveFoto(imagem: foto!)
            Toy.shared.save()
        }
        self.navigationController?.popToRootViewController(animated: true) //Dá pop até o RootViewController
    }

}
