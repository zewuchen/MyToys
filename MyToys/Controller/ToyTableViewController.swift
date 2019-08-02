//
//  ToyTableViewController.swift
//  MyToys
//
//  Created by Zewu Chen on 15/07/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//

import UIKit

class ToyTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate{

    let limiteNome = 30
    let limiteQuantidade = 5
    
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtQuantidade: UITextField!
    @IBOutlet weak var lblTamanho: UILabel!
    @IBOutlet weak var lblFaixaEtaria: UILabel!
    @IBOutlet weak var txtViewObservacoes: UITextView!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var btnProximo: UIBarButtonItem!
    
    var tamanho:String = ""
    var faixaEtaria:String = ""
    var edit:Bool = false
    
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
        
        
        //Editando brinquedo
        if edit == true{
            txtNome.text = Toy.shared.nome
            txtQuantidade.text = Toy.shared.quantidade?.description
            lblTamanho.text = Toy.shared.tamanho
            lblFaixaEtaria.text = Toy.shared.faixaEtaria
            if Toy.shared.observacoes != ""{
                txtViewObservacoes.text = Toy.shared.observacoes
            }
            self.navigationBar.title = "Editar Brinquedo"
            
            Toy.shared.edit = true
        }else{
            Toy.shared.clear()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblTamanho.text = Toy.shared.tamanho
        lblFaixaEtaria.text = Toy.shared.faixaEtaria
        
        if txtViewObservacoes.text == ""{
            txtViewObservacoes.text = "Observações"
            txtViewObservacoes.textColor = .lightGray
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath == [1, 0] || indexPath == [1, 1]), edit == true{
            btnProximo.isEnabled = true
        }
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
        checkObservacoes()
        textView.resignFirstResponder()
    }
    
    @IBAction func btnProximoAction(_ sender: Any) {
        Toy.shared.nome = txtNome.text
        Toy.shared.quantidade = Int64(txtQuantidade.text!)
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
    func checkObservacoes() {
        if txtViewObservacoes.text != Toy.shared.observacoes, txtNome.text != nil, txtNome.text != "", txtQuantidade.text != nil, txtQuantidade.text != "0", txtQuantidade.text != ""{
            btnProximo.isEnabled = true
        }else{
            btnProximo.isEnabled = false
        }
    }
    
}
