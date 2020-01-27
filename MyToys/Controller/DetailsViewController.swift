//
//  DetailsViewController.swift
//  MyToys
//
//  Created by Zewu Chen on 23/07/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//

import UIKit
import PDFKit

class DetailsViewController: UIViewController{

    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var lblNome: UILabel! {
        didSet {
            lblNome.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var lblQuantidade: UILabel!
    @IBOutlet weak var lblTamanho: UILabel!
    @IBOutlet weak var lblFaixaEtaria: UILabel!
    @IBOutlet weak var txtObservacoes: UITextView!
    @IBOutlet weak var page: UIPageControl!
    
    var indexFoto = 0
    let animationDuration: TimeInterval = 0.25
    let switchingInterval: TimeInterval = 3
    var transition = CATransition()
    var images:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgDetail.addBlackGradientLayerInForeground(frame: CGRect(x: 0, y: 0, width: imgDetail.frame.width, height: 200), colors: [UIColor.white, UIColor.init(white: 1, alpha: 0.5), UIColor.clear])
        page.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.view.tintColor = #colorLiteral(red: 0.3137254902, green: 0.4901960784, blue: 0.737254902, alpha: 1)
        
        if let ima = Toy.shared.foto{
            let fotos = ima.split(separator: ";")
            for foto in fotos {
                self.images.append(UIImage(contentsOfFile: FileHelper.getFile(filePathWithoutExtension: String(foto))!)!)
            }
            if images.count > 1 {
                self.indexFoto = 0
                self.page.currentPage = 0
                self.page.numberOfPages = images.count
                page.currentPageIndicatorTintColor = #colorLiteral(red: 0.01568627451, green: 0.03137254902, blue: 0.05882352941, alpha: 1)
                page.isHidden = false
            }
            self.imgDetail.image =  images[0]
        }
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeftGesture.direction = .left

        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRightGesture.direction = .right
        
        self.imgDetail.addGestureRecognizer(swipeLeftGesture)
        self.imgDetail.addGestureRecognizer(swipeRightGesture)
        
        guard let id = Toy.shared.id else {return}
        guard let nome = Toy.shared.nome else {return}
        guard let quantidade = Toy.shared.quantidade?.description else {return}
        Notification.shared.update(id: id, nome: nome)
        
        self.lblNome.text = Toy.shared.nome
        if Int(quantidade)! > 1{
            self.lblQuantidade.text = "Quantidade: \(quantidade) unidades"
        }else{
            self.lblQuantidade.text = "Quantidade: \(quantidade) unidade"
        }
        
        self.lblTamanho.text = "Tamanho: \(String(Toy.shared.tamanho!))"
        
        self.lblFaixaEtaria.text = "Faixa Etária: \(String(Toy.shared.faixaEtaria!))"
        
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
                indexFoto = indexFoto > 0 ? indexFoto - 1 : images.count - 1
            } else {
                transition.subtype = CATransitionSubtype.fromRight
                indexFoto = indexFoto < images.count - 1 ? indexFoto + 1 : 0
            }
            imgDetail.layer.add(transition, forKey: kCATransition)
            if images.count != 0 {
                imgDetail.image = images[indexFoto]
                page.currentPage = indexFoto
            }
            CATransaction.commit()
        }
    }
    
    func createPDF() {

        let pdfMetaData = [
            kCGPDFContextCreator: "Brinquedos",
            kCGPDFContextAuthor: "MyToysApp"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageRect = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            
            context.beginPage()
            
            let titleAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
            let textAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
            
            let imagem = images[0]
            let imagemRect = CGRect(x: 0, y: 0, width: view.frame.width, height: imgDetail.frame.height)
            imagem.draw(in: imagemRect)
            
            let title = "\(String(Toy.shared.nome!))"
            title.draw(at: CGPoint(x: 15, y: imgDetail.frame.height + 20), withAttributes: titleAttributes)
            
            let quantidade = "Quantidade: \(String(Toy.shared.quantidade!)) unidades"
            quantidade.draw(at: CGPoint(x: 15, y: imgDetail.frame.height + 55), withAttributes: textAttributes)
            
            let tamanho = "Tamanho: \(String(Toy.shared.tamanho!))"
            tamanho.draw(at: CGPoint(x: 15, y: imgDetail.frame.height + 80), withAttributes: textAttributes)
            
            let faixa = "Faixa Etária: \(String(Toy.shared.faixaEtaria!))"
            faixa.draw(at: CGPoint(x: 15, y: imgDetail.frame.height + 105), withAttributes: textAttributes)
            
            if Toy.shared.observacoes != nil {
                let observacoes = "Observações: \n \(String(Toy.shared.observacoes!))"
                observacoes.draw(at: CGPoint(x: 15, y: imgDetail.frame.height + 130), withAttributes: textAttributes)
            } else {
                let observacoes = "Não há observações"
                observacoes.draw(at: CGPoint(x: 15, y: imgDetail.frame.height + 130), withAttributes: textAttributes)
            }
            
        }
        
        let vc = UIActivityViewController(activityItems: [data],applicationActivities:[])
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnCompartilhar(_ sender: Any) {
        createPDF()
    }
    
}

extension UIView {
    // For insert layer in Foreground
    func addBlackGradientLayerInForeground(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
    }
    
    // For insert layer in background
    func addBlackGradientLayerInBackground(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        self.layer.insertSublayer(gradient, at: 0)
    }
}
