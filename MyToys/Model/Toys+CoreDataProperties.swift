//
//  Toys+CoreDataProperties.swift
//  MyToys
//
//  Created by Zewu Chen on 17/07/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//
//

import Foundation
import CoreData


extension Toys {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Toys> {
        return NSFetchRequest<Toys>(entityName: "Toys")
    }

    @NSManaged public var faixaEtaria: String?
    @NSManaged public var nome: String?
    @NSManaged public var observacoes: String?
    @NSManaged public var quantidade: String?
    @NSManaged public var tamanho: String?

}
