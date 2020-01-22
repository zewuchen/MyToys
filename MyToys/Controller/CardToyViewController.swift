//
//  CardToyViewController.swift
//  MyToys
//
//  Created by Zewu Chen on 21/01/20.
//  Copyright © 2020 Zewu Chen. All rights reserved.
//

import UIKit

class CardToyViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var brinquedos:[Toys] = Toy.shared.brinquedos
    var wallpaper:UIImageView = UIImageView(image: UIImage(named: "wallpaper"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.title = "MyToys"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dados()
        setWallpaper()
    }

    override func viewWillDisappear(_ animated: Bool) {
        wallpaper.removeFromSuperview()
    }
    
    /**
    *Realiza a busca dos dados e atribui à variável brinquedos, atualiza a tableView*
    - Parameters: Nenhum
    - Returns: Nenhum
    */
    func dados(){
        Toy.shared.fetchData()
        brinquedos = Toy.shared.brinquedos
        collectionView.reloadData()
    }

    /**
    *Converte o formato da data*
    - Parameters:
        - date: date de criação do brinquedo
    - Returns: String
    */
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
    
    /**
    *Caso não haja brinquedos, adiciona o wallpaper*
    - Parameters: Nenhum
    - Returns: Nenhum
    */
    func setWallpaper(){
        if brinquedos.count == 0 {
            wallpaper.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2)
            self.view.addSubview(wallpaper)
            wallpaper.center.x = self.view.center.x
            wallpaper.center.y = self.view.center.y - 100
        }
    }
    

}

extension CardToyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brinquedos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToyCard", for: indexPath) as! CardToysCollectionViewCell

        cell.date.text = stringFromDate(brinquedos[indexPath.row].dateAdd! as Date)
        if let foto =  brinquedos[indexPath.row].foto{
            cell.image.image = UIImage(contentsOfFile: FileHelper.getFile(filePathWithoutExtension: foto)!)
        }

        return cell
    }
}

extension CardToyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
