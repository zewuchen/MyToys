//
//  ToyTableViewController.swift
//  MyToys
//
//  Created by Zewu Chen on 15/07/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//

import UIKit

class ToyTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate{

    let limiteNome = 35
    let limiteQuantidade = 10
    
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtQuantidade: UITextField!
    @IBOutlet weak var txtViewObservacoes: UITextView!
    
    var tamanho:String = ""
    var faixaEtaria:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtNome.delegate = self
        self.txtQuantidade.delegate =  self
        self.txtViewObservacoes.delegate = self
    }
    
    //Limite de caracteres
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtNome{
            return txtNome.text!.count + string.count <= self.limiteNome
        }
        return txtQuantidade.text!.count + string.count <= self.limiteQuantidade
    }
    
    //Placeholder no TextView
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == "Observações" && textView.textColor == .lightGray)
        {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = "Observações"
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }

    @IBAction func btnProximo(_ sender: Any) {
        Toy.shared.nome = txtNome.text
        Toy.shared.quantidade = txtQuantidade.text
        Toy.shared.observacoes = txtViewObservacoes.text
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "camera")
        self.navigationController!.pushViewController(controller, animated: true)
    }
}
