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
    var editando: Bool = false 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationItem.title = "MyToys"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dados()
        setWallpaper()
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        wallpaper.removeFromSuperview()
    }
    
    @IBAction func btnExcluir(_ sender: Any) {
        if !editando {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteItem))
            navigationItem.rightBarButtonItem?.isEnabled = false
            
            let indexPaths = collectionView.indexPathsForVisibleItems
            for indexPath in indexPaths {
                let cell = collectionView.cellForItem(at: indexPath) as! CardToysCollectionViewCell
                cell.isInEditingMode = editando
            }
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newToy))
            navigationItem.rightBarButtonItem?.isEnabled = true
            
            let indexPaths = collectionView.indexPathsForVisibleItems
            for indexPath in indexPaths {
                let cell = collectionView.cellForItem(at: indexPath) as! CardToysCollectionViewCell
                cell.isInEditingMode = false
            }
        }
        editando = !editando
        
        collectionView.allowsMultipleSelection = editando
    }
    
    @IBAction func newToy(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "newToy")
        self.navigationController!.pushViewController(controller, animated: true)
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
            wallpaper.center.y = self.view.center.y
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
        
        cell.bringSubviewToFront(cell.checkmarkLabel)

        return cell
    }
}

extension CardToyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if editando {
            navigationItem.rightBarButtonItem?.isEnabled = true
            let cell = collectionView.cellForItem(at: indexPath) as! CardToysCollectionViewCell
            cell.isInEditingMode = editando
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
            Toy.shared.fetchToy(id: brinquedos[indexPath.row].id!)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "details")
            self.navigationController!.pushViewController(controller, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        let alerta = UIAlertController(title: "Tem certeza que deseja excluir?", message: "Os dados não poderão ser recuperados", preferredStyle: .alert)
        let aceitar = UIAlertAction(title: "Excluir", style: .destructive){
            UIAlertAction in
            
            if let selectedCells = self.collectionView.indexPathsForSelectedItems {
              
                for item in selectedCells {
                    Toy.shared.delete(id: self.brinquedos[item.row].id!)
                    self.brinquedos.remove(at: item.row)
                }
                
                self.collectionView.deleteItems(at: selectedCells)
                self.collectionView.reloadData()
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
            self.dados()
            self.setWallpaper()
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel){
            UIAlertAction in
        }

        alerta.addAction(aceitar)
        alerta.addAction(cancelar)
        present(alerta, animated: true, completion: nil)
    }
}
