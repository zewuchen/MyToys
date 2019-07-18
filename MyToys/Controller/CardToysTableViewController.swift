//
//  CardToysTableViewController.swift
//  MyToys
//
//  Created by Zewu Chen on 15/07/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//

import UIKit
import CoreData

class CardToysTableViewController: UITableViewController{
    
    var context: NSManagedObjectContext?
    var brinquedos:[Toys] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        fetchData()

        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.title = "MyToys"
        tableView.rowHeight = 130

    }
    
    func fetchData(){
        do{
            brinquedos = try context!.fetch(Toys.fetchRequest())
            brinquedos.reverse()
            tableView.reloadData()
        } catch{
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return brinquedos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Card") as! CardToysTableViewCell
        cell.txtName.text = brinquedos[indexPath.row].nome
        
        return cell
    }
    
    // Deleção de linha
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        if tableView.isEditing {
//            return .delete
//        }
//        return .none
//    }
    
    // Edição de linha
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
