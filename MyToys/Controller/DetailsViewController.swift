//
//  DetailsViewController.swift
//  MyToys
//
//  Created by Zewu Chen on 23/07/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController{

    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblQuantidade: UILabel!
    @IBOutlet weak var lblTamanho: UILabel!
    @IBOutlet weak var lblFaixaEtaria: UILabel!
    @IBOutlet weak var txtObservacoes: UITextView!
    
    //ViewCards
    @IBOutlet weak var view1: UIView! {
        didSet {
            view1.layer.cornerRadius = 13
            view1.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var view2: UIView! {
        didSet {
            view2.layer.cornerRadius = 13
            view2.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var view3: UIView! {
        didSet {
            view3.layer.cornerRadius = 13
            view3.layer.borderWidth = 1

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.view.tintColor = #colorLiteral(red: 0.4748159051, green: 0.75166291, blue: 0.9633973241, alpha: 1)
        
        if let ima = Toy.shared.foto{
            self.imgDetail.image = UIImage(contentsOfFile: FileHelper.getFile(filePathWithoutExtension: ima)!)
        }
        
        guard let id = Toy.shared.id else {return}
        guard let nome = Toy.shared.nome else {return}
        guard let quantidade = Toy.shared.quantidade?.description else {return}
        Notification.shared.update(id: id, nome: nome)
        
        self.lblNome.text = Toy.shared.nome
        self.lblQuantidade.text = "\(quantidade) \n unidades"
        self.lblTamanho.text = Toy.shared.tamanho
        
        let faixaEtaria = Toy.shared.faixaEtaria
        guard let result = faixaEtaria?.split(separator: " ") else {return}
        self.lblFaixaEtaria.text = "\(result[0]) \n \(result[1])"
        
        if Toy.shared.observacoes == ""{
            self.txtObservacoes.text = "Não há observações."
        }else{
            self.txtObservacoes.text = Toy.shared.observacoes
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundImage(for: .default)
        self.navigationController?.navigationBar.shadowImage = .none
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        self.navigationController?.view.tintColor = #colorLiteral(red: 0.4748159051, green: 0.75166291, blue: 0.9633973241, alpha: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            if let nextVC = segue.destination as? ToyTableViewController {
                nextVC.edit = true
            }
        }
    }
}
