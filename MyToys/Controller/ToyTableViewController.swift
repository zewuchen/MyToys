//
//  ToyTableViewController.swift
//  MyToys
//
//  Created by Zewu Chen on 15/07/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//

import UIKit

class ToyTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate{

    @IBOutlet weak var btnExcluir: UIButton!
    @IBOutlet weak var btnFoto: UIButton!
    @IBOutlet weak var page: UIPageControl!
    @IBOutlet weak var imgFoto: UIImageView!
    let limiteNome = 30
    let limiteQuantidade = 5

    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtQuantidade: UITextField!
    @IBOutlet weak var lblTamanho: UILabel!
    @IBOutlet weak var lblFaixaEtaria: UILabel!
    @IBOutlet weak var txtViewObservacoes: UITextView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var btnSalvar: UIBarButtonItem!
    
    var indexFoto = 0
    let animationDuration: TimeInterval = 0.25
    let switchingInterval: TimeInterval = 3
    var transition = CATransition()
    
    var tamanho:String = ""
    var faixaEtaria:String = ""
    var edit:Bool = false
    var images:[UIImage] = []
    var filepathImagensSalvas:[String] = []
    var novasImagens:[UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtNome.delegate = self
        self.txtNome.addTarget(self, action: #selector(txtNomeDidChange(_:)), for: .editingChanged)
        self.txtQuantidade.delegate =  self
        self.txtQuantidade.addTarget(self, action: #selector(txtQuantidadeDidChange(_:)), for: .editingChanged)
        self.txtViewObservacoes.delegate = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        layout()
        setSwipe()
        
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
            
            if let ima = Toy.shared.foto{
                let fotos = ima.split(separator: ";")
                for foto in fotos {
                    self.images.append(UIImage(contentsOfFile: FileHelper.getFile(filePathWithoutExtension: String(foto))!)!)
                    self.filepathImagensSalvas.append(String(foto))
                }
                reloadPageControl(acao: "Editando")
                btnExcluir.isHidden = false
            }
        } else {
            Toy.shared.clear()
        }
    }
    
    /**
    *Configurações de layout  e cores*
    - Parameters: Nenhum
    - Returns: Nenhum
    */
    func layout() {
        btnExcluir.isHidden = true
        btnExcluir.layer.cornerRadius = 28
        btnFoto.layer.cornerRadius = 28
        page.currentPageIndicatorTintColor = #colorLiteral(red: 0.01568627451, green: 0.03137254902, blue: 0.05882352941, alpha: 1)
        view.bringSubviewToFront(page)
    }
    
    /**
    *Adiciona o swipe na UIImage*
    - Parameters: Nenhum
    - Returns: Nenhum
    */
    func setSwipe() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeftGesture.direction = .left

        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRightGesture.direction = .right
        
        self.imgFoto.addGestureRecognizer(swipeLeftGesture)
        self.imgFoto.addGestureRecognizer(swipeRightGesture)
    }
    
    /**
    *Atualiza a page control e a imagem apresentada*
    - Parameters:
        - acao: atualizar de acordo com um ação específicada
    - Returns: Nenhum
    */
    func reloadPageControl(acao: String) {
        if acao == "Excluir", images.count != 0 {
            indexFoto = indexFoto - 1 > -1 ? indexFoto - 1 : 0
            page.currentPage = indexFoto
            self.images.remove(at: indexFoto)
            if images.count > 0 {
                imgFoto.image = images[indexFoto]
            }
            page.numberOfPages = self.images.count
        } else if acao == "Adicionar"{
            page.numberOfPages = self.images.count
            page.currentPage = self.images.count-1
            indexFoto = self.images.count-1
            imgFoto.image = images[indexFoto]
        } else if acao == "Editando" {
            page.numberOfPages = self.images.count
            page.currentPage = 0
            indexFoto = 0
            imgFoto.image = images[indexFoto]
        }
        
        
        if images.count == 0 {
            btnExcluir.isHidden = true
            imgFoto.image = UIImage(named: "Picture Icon")
        }
    }
    
    @objc func swipeLeft() {
        animateImageView(direcao: "Esquerdo")
    }

    @objc func swipeRight() {
        animateImageView(direcao: "Direito")
    }
    
    /**
    *Converte o formato da data*
    - Parameters:
        - direcao: string informando a direcao do swipe na UIImage
    - Returns: Nenhum
    */
    func animateImageView(direcao: String) {
        if images.count > 1 {
            CATransaction.begin()

            CATransaction.setAnimationDuration(animationDuration)

            transition.type = CATransitionType.push
            if direcao == "Direito" {
                transition.subtype = CATransitionSubtype.fromLeft
                indexFoto = indexFoto - 1 > -1 ? indexFoto - 1 : images.count - 1
            } else {
                transition.subtype = CATransitionSubtype.fromRight
                indexFoto = indexFoto < images.count - 1 ? indexFoto + 1 : 0
            }
            imgFoto.layer.add(transition, forKey: kCATransition)
            if images.count != 0 {
                imgFoto.image = images[indexFoto]
                page.currentPage = indexFoto
            }
            CATransaction.commit()
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
            btnSalvar.isEnabled = true
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        switch (indexPath.section, indexPath.row) {
            case (1, 0):
                print("Code")

            default: break
        }

        return cell
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

    @IBAction func txtNomeDidChange(_ sender: Any) {
        checkInputValues()

    }

    @IBAction func txtQuantidadeDidChange(_ sender: Any) {
        checkInputValues()
    }

    /**
    *Checa se os campos (nome, quantidade) estão preenchidos*
    - Parameters: Nenhum
    - Returns: Nenhum
    */
    func checkInputValues() {
        if txtNome.text != nil, txtNome.text != "", txtQuantidade.text != nil, txtQuantidade.text != "0", txtQuantidade.text != ""{
            btnSalvar.isEnabled = true
        }else{
            btnSalvar.isEnabled = false
        }
    }

    /**
    *Checa se os campos (nome, quantidade, observações) estão preenchidos*
    - Parameters: Nenhum
    - Returns: Nenhum
    */
    func checkObservacoes() {
        if txtViewObservacoes.text != Toy.shared.observacoes, txtNome.text != nil, txtNome.text != "", txtQuantidade.text != nil, txtQuantidade.text != "0", txtQuantidade.text != ""{
            btnSalvar.isEnabled = true
        }else{
            btnSalvar.isEnabled = false
        }
    }
    
    @IBAction func btnExcluir(_ sender: Any) {
        let alerta = UIAlertController(title: "Tem certeza que deseja excluir?", message: "A foto não poderá ser recuperada", preferredStyle: .alert)
        let aceitar = UIAlertAction(title: "Excluir", style: .destructive){
            UIAlertAction in
            
            if self.edit {
                var jaRemovido = true
                
                for i in 0 ... self.novasImagens.count - 1 {
                    if self.images[self.indexFoto] == self.novasImagens[i] {
                        self.novasImagens.remove(at: i)
                        jaRemovido = false
                        print("removido recem adicionada")
                    }
                }
                
                if jaRemovido {
                    Toy.shared.deleteFoto(fileURL: self.filepathImagensSalvas[self.indexFoto])
                    self.filepathImagensSalvas.remove(at: self.indexFoto)
                }
                
            }
            
            self.reloadPageControl(acao: "Excluir")
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel){
            UIAlertAction in
        }

        alerta.addAction(aceitar)
        alerta.addAction(cancelar)
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func btnFoto(_ sender: Any) {
        Camera().selecionadorImagem(self){ imagem in
            self.images.append(imagem)
            self.reloadPageControl(acao: "Adicionar")
            self.btnExcluir.isHidden = false
            if self.edit {
                self.novasImagens.append(imagem)
            }
        }
    }
    
    @IBAction func btnSalvar(_ sender: Any) {
        Toy.shared.nome = txtNome.text
        Toy.shared.quantidade = Int64(txtQuantidade.text!)
        Toy.shared.observacoes = txtViewObservacoes.text
        
        var filenameFotos:String = ""
        
        if edit, let id = Toy.shared.id {
            for foto in novasImagens {
                filenameFotos += ";"
                let nome = Toy.shared.saveFoto(imagem: foto)
                filenameFotos += nome
            }
            for antigaFoto in filepathImagensSalvas {
                filenameFotos += ";"
                filenameFotos += antigaFoto
            }
            Toy.shared.foto = filenameFotos
            Toy.shared.update(id: id)
        } else {
            for foto in images {
                filenameFotos += ";"
                let nome = Toy.shared.saveFoto(imagem: foto)
                filenameFotos += nome
            }
            Toy.shared.foto = filenameFotos
            Toy.shared.save()
        }
    
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
