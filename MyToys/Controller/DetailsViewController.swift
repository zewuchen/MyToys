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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.view.tintColor = .white
        
        if let ima = Toy.shared.foto{
            self.imgDetail.image = UIImage(contentsOfFile: ima)
        }
        
        guard let id = Toy.shared.id else {return}
        guard let nome = Toy.shared.nome else {return}
        guard let quantidade = Toy.shared.quantidade?.description else {return}
        Notification.shared.update(id: id, nome: nome)
        
        self.lblNome.text = Toy.shared.nome
        self.lblQuantidade.text = quantidade
        self.lblTamanho.text = Toy.shared.tamanho
        self.lblFaixaEtaria.text = Toy.shared.faixaEtaria
        self.txtObservacoes.text = Toy.shared.observacoes
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
