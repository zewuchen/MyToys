//
//  AgeGroupTableViewController.swift
//  MyToys
//
//  Created by Zewu Chen on 16/07/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//

import UIKit

class AgeGroupTableViewController: UITableViewController {
    
    let faixas:[String] = Toy.shared.faixas
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return faixas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as! OptionTableViewCell
        cell.lblTextoFaixaEtaria.text = faixas[indexPath.row]
        
        if faixas[indexPath.row] == Toy.shared.faixaEtaria{
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func desmarca(_ tableView: UITableView){
        for i in 0...faixas.count{
            tableView.cellForRow(at: IndexPath(row: i, section: 0))?.accessoryType = .none
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        desmarca(tableView)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        Toy.shared.faixaEtaria = faixas[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }

}
