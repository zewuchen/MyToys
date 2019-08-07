//
//  CardToysTableViewController.swift
//  MyToys
//
//  Created by Zewu Chen on 15/07/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//

import UIKit

class CardToysTableViewController: UITableViewController{
    
    var brinquedos:[Toys] = Toy.shared.brinquedos
    var wallpaper:UIImageView = UIImageView(image: UIImage(named: "wallpaper"))

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.title = "MyToys"
        tableView.rowHeight = 180
        
    }
    
    func dados(){
        Toy.shared.fetchData()
        brinquedos = Toy.shared.brinquedos
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dados()
        setWallpaper()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        wallpaper.removeFromSuperview()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return brinquedos.count
    }
    
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Card") as! CardToysTableViewCell

        //cell.txtName.text = brinquedos[indexPath.row].nome
        cell.txtName.text = ""
        cell.txtDate.text = stringFromDate(brinquedos[indexPath.row].dateAdd! as Date)
        if let foto =  brinquedos[indexPath.row].foto{
            cell.foto.image = UIImage(contentsOfFile: FileHelper.getFile(filePathWithoutExtension: foto)!)
        }
        
        return cell
    }
    
    // Deleção de linha
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let alerta = UIAlertController(title: "Tem certeza que deseja excluir?", message: "Os dados não poderão ser recuperados", preferredStyle: .alert)
            let aceitar = UIAlertAction(title: "Excluir", style: .destructive){
                UIAlertAction in
                
                //tableView.deleteRows(at: [indexPath], with: .fade)
                Toy.shared.delete(id: self.brinquedos[indexPath.row].id!)
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
    
    func setWallpaper(){
        if brinquedos.count == 0 {
            wallpaper.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2)
            self.view.addSubview(wallpaper)
            wallpaper.center.x = self.view.center.x
            wallpaper.center.y = self.view.center.y - 100
        }
    }
    
    // Edição de linha
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Toy.shared.fetchToy(id: brinquedos[indexPath.row].id!)
    }

}
