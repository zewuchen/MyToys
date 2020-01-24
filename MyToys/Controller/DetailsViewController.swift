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
    @IBOutlet weak var page: UIPageControl!
    
    var indexFoto = 0
    let animationDuration: TimeInterval = 0.25
    let switchingInterval: TimeInterval = 3
    var transition = CATransition()
    var images:[UIImage] = []
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
            let fotos = ima.split(separator: ";")
            for foto in fotos {
                self.images.append(UIImage(contentsOfFile: FileHelper.getFile(filePathWithoutExtension: String(foto))!)!)
            }
            self.indexFoto = 0
            self.page.currentPage = 0
            self.page.numberOfPages = images.count
            self.imgDetail.image =  images[indexFoto]
            page.currentPageIndicatorTintColor = #colorLiteral(red: 0.01568627451, green: 0.03137254902, blue: 0.05882352941, alpha: 1)
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
            self.lblQuantidade.text = "\(quantidade) \n unidades"
        }else{
            self.lblQuantidade.text = "\(quantidade) \n unidade"
        }
        
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
}
