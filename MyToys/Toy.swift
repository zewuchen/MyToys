import CoreData
import UIKit
import Foundation

class Toy{
    
    static let shared:Toy = Toy()

    public var faixaEtaria: String?
    public var nome: String?
    public var observacoes: String?
    public var quantidade: String?
    public var tamanho: String?
    
    var context: NSManagedObjectContext?
    
    private init(){
        self.faixaEtaria = ""
        self.nome = ""
        self.observacoes = ""
        self.quantidade = ""
        self.tamanho = ""
        
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func clear(){
        self.faixaEtaria = ""
        self.nome = ""
        self.observacoes = ""
        self.quantidade = ""
        self.tamanho = ""
    }
    
    func save(){
        guard let context = self.context else {return}
        
        
        let registry = NSEntityDescription.insertNewObject(forEntityName: "Toys", into: context) as! Toys
        
        registry.nome = self.nome
        registry.faixaEtaria = self.faixaEtaria
        registry.observacoes = self.observacoes
        registry.quantidade = self.quantidade
        registry.tamanho = self.tamanho
        
        do {
            try context.save()
            clear()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
}
