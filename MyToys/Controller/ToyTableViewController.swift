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
    @IBOutlet weak var btnProximo: UIBarButtonItem!
    
    var tamanho:String = ""
    var faixaEtaria:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtNome.delegate = self
        self.txtNome.addTarget(self, action: #selector(txtNomeDidChange(_:)), for: .editingChanged)
        self.txtQuantidade.delegate =  self
        self.txtQuantidade.addTarget(self, action: #selector(txtQuantidadeDidChange(_:)), for: .editingChanged)
        self.txtViewObservacoes.delegate = self
        btnProximo.isEnabled = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //Limite de caracteres
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtNome{
            return txtNome.text!.count + string.count <= self.limiteNome
        }
        return txtQuantidade.text!.count + string.count <= self.limiteQuantidade
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtNome{
            self.view.endEditing(true)
        }
        
        return true
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
    
    @IBAction func btnProximoAction(_ sender: Any) {
        Toy.shared.nome = txtNome.text
        Toy.shared.quantidade = txtQuantidade.text
        Toy.shared.observacoes = txtViewObservacoes.text
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "camera")
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    @IBAction func txtNomeDidChange(_ sender: Any) {
        checkInputValues()
        
    }
    
    @IBAction func txtQuantidadeDidChange(_ sender: Any) {
        checkInputValues()
    }
    
    func checkInputValues() {
        if txtNome.text != nil, txtNome.text != "", txtQuantidade.text != nil, txtQuantidade.text != "0", txtQuantidade.text != ""{
            btnProximo.isEnabled = true
        }else{
            btnProximo.isEnabled = false
        }
    }
    
    
}
