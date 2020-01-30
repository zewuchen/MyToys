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
    var firstFoto:Bool = false
    var filepathImagensSalvas:[String] = []
    var filepathImagensExcluidas:[String] = []
    var novasImagens:[UIImage] = []
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtQuantidade.delegate =  self
        self.txtNome.delegate = self
        self.txtNome.addTarget(self, action: #selector(txtNomeDidChange(_:)), for: .editingChanged)
        self.txtQuantidade.addTarget(self, action: #selector(txtQuantidadeDidChange(_:)), for: .editingChanged)
        self.txtViewObservacoes.delegate = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
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
                firstFoto = true
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
            indexFoto = indexFoto  >= images.count ? 0 : indexFoto
            imgFoto.image = images[indexFoto]
            page.numberOfPages = self.images.count
            page.currentPage = indexFoto
        } else if acao == "Adicionar"{
            page.numberOfPages = self.images.count
            page.currentPage = self.images.count-1
            page.isHidden = false
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
            page.isHidden = true
            imgFoto.image = UIImage(named: "Picture Icon")
            firstFoto = false
        }
    }
    
    /**
    *Chama a função para animar a UIImage para o lado Esquerdo*
    - Parameters: Nenhum
    - Returns: Nenhum
    */
    @objc func swipeLeft() {
        animateImageView(direcao: "Esquerdo")
    }
    
    /**
    *Chama a função para animar a UIImage para o lado Direito*
    - Parameters: Nenhum
    - Returns: Nenhum
    */
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
            case (0, 0):
                break
            
            case (1, 1):
                break
            
            case (2, 1):
                break
            
            case (3, 0):
                break

            default:
                let bottomBorder = CALayer()

                bottomBorder.frame = CGRect(x: 15.0, y: 49.5, width: view.frame.width, height: 0.5)
                bottomBorder.backgroundColor = UIColor(white: 0.8, alpha: 1.0).cgColor
                cell.contentView.layer.addSublayer(bottomBorder)
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
//        checkObservacoes()
        textView.resignFirstResponder()
    }

    @IBAction func txtNomeDidChange(_ sender: Any) {
//        checkInputValues()

    }

    @IBAction func txtQuantidadeDidChange(_ sender: Any) {
//        checkInputValues()
    }

//    /**
//    *Checa se os campos (nome, quantidade) estão preenchidos*
//    - Parameters: Nenhum
//    - Returns: Nenhum
//    */
//    func checkInputValues() {
//        if txtNome.text != nil, txtNome.text != "", txtQuantidade.text != nil, txtQuantidade.text != "0", txtQuantidade.text != ""{
//            btnSalvar.isEnabled = true
//        }else{
//            btnSalvar.isEnabled = false
//        }
//    }

    /**
    *Checa se os campos (nome, quantidade, observações) estão preenchidos*
    - Parameters: Nenhum
    - Returns: Nenhum
    */
//    func checkObservacoes() {
//        if txtViewObservacoes.text != Toy.shared.observacoes, txtNome.text != nil, txtNome.text != "", txtQuantidade.text != nil, txtQuantidade.text != "0", txtQuantidade.text != ""{
//            btnSalvar.isEnabled = true
//        }else{
//            btnSalvar.isEnabled = false
//        }
//    }
    
    /**
    *Checa se os campos (nome, quantidade, foto) estão preenchidos*
    - Parameters: Nenhum
    - Returns: Bool, True para válido, False para inválido
    */
    func checkFields() -> Bool {
        guard let nome = txtNome.text else {return false}
        guard let quantidade = txtQuantidade.text else {return false}
        if nome != "", quantidade != "0", quantidade != "", firstFoto {
            return true
        } else {
            
            var message = ""
            
            if nome == ""{
                message += "O campo nome precisa ser preenchido.\n "
                txtNome.layer.borderColor = #colorLiteral(red: 0.8431372549, green: 0.1490196078, blue: 0.2392156863, alpha: 1)
                txtNome.layer.borderWidth = 0.5
            } else {
                txtNome.layer.borderWidth = 0
            }
            
            if quantidade == "0" || quantidade == "" {
                message += "O campo quantidade precisa ser preenchido.\n "
                txtQuantidade.text = ""
                txtQuantidade.layer.borderColor = #colorLiteral(red: 0.8431372549, green: 0.1490196078, blue: 0.2392156863, alpha: 1)
                txtQuantidade.layer.borderWidth = 0.5
            } else {
                txtQuantidade.layer.borderWidth = 0
            }
            
            if !firstFoto {
                message += "É necessário adicionar uma foto."
                imgFoto.layer.borderColor = #colorLiteral(red: 0.8431372549, green: 0.1490196078, blue: 0.2392156863, alpha: 1)
                imgFoto.layer.borderWidth = 0.5
            } else {
                imgFoto.layer.borderWidth = 0
            }
                
            let alerta = UIAlertController(title: "Dados Inválidos", message: "\(message)", preferredStyle: .alert)
            let aceitar = UIAlertAction(title: "OK", style: .cancel)

            alerta.addAction(aceitar)
            present(alerta, animated: true, completion: nil)
            
            return false
        }
    }
    
    /**
    *Exclui a foto atual no UIImage*
    - Parameters:
        - Any
    - Returns: Nenhum
    */
    @IBAction func btnExcluir(_ sender: Any) {
        let alerta = UIAlertController(title: "Tem certeza que deseja excluir?", message: "A foto não poderá ser recuperada", preferredStyle: .alert)
        let aceitar = UIAlertAction(title: "Excluir", style: .destructive){
            UIAlertAction in
            
            if self.edit {
                var jaRemovido = true
                
                if self.novasImagens.count == 1 {
                    if self.images[self.indexFoto] == self.novasImagens[0] {
                        self.novasImagens.remove(at: 0)
                        jaRemovido = false
                        print("removido recem adicionada")
                    }
                } else if self.novasImagens.count > 1 {
                    for i in 0 ..< self.novasImagens.count - 1 {
                        if self.images[self.indexFoto] == self.novasImagens[i] {
                            self.novasImagens.remove(at: i)
                            jaRemovido = false
                            print("removido recem adicionada")
                        }
                    }
                }
                
                if jaRemovido {
                    self.filepathImagensExcluidas.append(self.filepathImagensSalvas[self.indexFoto])
                    self.filepathImagensSalvas.remove(at: self.indexFoto)
                }
                
            }
            self.images.remove(at: self.indexFoto)
            
            self.reloadPageControl(acao: "Excluir")
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel){
            UIAlertAction in
        }

        alerta.addAction(aceitar)
        alerta.addAction(cancelar)
        present(alerta, animated: true, completion: nil)
    }
    
    /**
    *Chama um picker para saber de onde será adicionada a foto e chama a função de adicionar foto*
    - Parameters:
        - Any
    - Returns: Nenhum
    */
    @IBAction func btnFoto(_ sender: Any) {
        
        let alerta = UIAlertController(title: "Escolha uma opção", message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Câmera", style: .default){
            UIAlertAction in
            self.openCamera(tipo: "camera")
        }

        let galeria = UIAlertAction(title: "Galeria", style: .default){
            UIAlertAction in
            self.openCamera(tipo: "galeria")
        }

        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel){
            UIAlertAction in
        }
        
        alerta.addAction(camera)
        alerta.addAction(galeria)
        alerta.addAction(cancelar)
        
        if let popoverController = alerta.popoverPresentationController {
          popoverController.sourceView = self.view
          popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
          popoverController.permittedArrowDirections = []
        }
        
        present(alerta, animated: true, completion: nil)
        
//        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
//            imagePicker.delegate = self
//            imagePicker.sourceType = .savedPhotosAlbum
//            imagePicker.allowsEditing = false
//
//            present(imagePicker, animated: true, completion: nil)
//        }
//        Camera().selecionadorImagem(self){ imagem in
//            self.images.append(imagem)
//            self.reloadPageControl(acao: "Adicionar")
//            self.btnExcluir.isHidden = false
//            if self.edit {
//                self.novasImagens.append(imagem)
//            }
//            self.firstFoto = true
//        }
    }
    
    /**
    *Abre o selecionar de imagem*
    - Parameters:
        - tipo: Se a foto virá da biblioteca ou da câmera
    - Returns: Nenhum
    */
    func openCamera(tipo: String) {
        if tipo == "camera" {
            if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                imagePicker.sourceType = .camera
                present(imagePicker, animated: true, completion: nil)
            } else {
                let alerta = UIAlertController(title: "Alerta", message: "Não foi possível acessar sua câmera", preferredStyle: .alert)
                let cancelar = UIAlertAction(title: "OK", style: .cancel){
                    UIAlertAction in
                }
                alerta.addAction(cancelar)
                present(alerta, animated: true, completion: nil)
            }
        } else if tipo == "galeria" {
            imagePicker.sourceType = .savedPhotosAlbum
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    /**
    *Salva o brinquedo*
    - Parameters:
        - Any
    - Returns: Nenhum
    */
    @IBAction func btnSalvar(_ sender: Any) {
        if checkFields() {
            Toy.shared.nome = txtNome.text
                Toy.shared.quantidade = Int64(txtQuantidade.text!)
                Toy.shared.observacoes = txtViewObservacoes.text
                
                var filenameFotos:String = ""
                
                if edit, let id = Toy.shared.id {
                    for fotoExcluida in filepathImagensExcluidas {
                        Toy.shared.deleteFoto(fileURL: fotoExcluida)
                    }
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
    
}

extension ToyTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        //Desfaz a tela da Galeria que foi gerada
        picker.dismiss(animated: true, completion: nil)

        //Verifica o arquivo aberto é realmente uma imagem
        guard let image = info[.originalImage] as? UIImage else {
            return
        }

        self.images.append(image)
        self.reloadPageControl(acao: "Adicionar")
        self.btnExcluir.isHidden = false
        if self.edit {
            self.novasImagens.append(image)
        }
        self.firstFoto = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Desfaz a tela da Galeria que foi gerada
        picker.dismiss(animated: true, completion: nil)
    }
}
