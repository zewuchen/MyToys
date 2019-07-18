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
    public var foto: String?
    
    var context: NSManagedObjectContext?
    
    private init(){
        self.faixaEtaria = ""
        self.nome = ""
        self.observacoes = ""
        self.quantidade = ""
        self.tamanho = ""
        self.foto = ""
        
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func clear(){
        self.faixaEtaria = ""
        self.nome = ""
        self.observacoes = ""
        self.quantidade = ""
        self.tamanho = ""
        self.foto = ""
    }
    
    func saveFoto(foto:UIImage){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //let fileName = "\(Date()).jpg"
        let fileName = "\(UUID()).jpg"
        print(fileName)
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = foto.jpegData(compressionQuality:  1.0), !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                Toy.shared.foto = fileURL.path
                print("Foto salva")
            } catch {
                print("Erro ao salvar a foto:", error)
            }
        }
    }
    
    func save(){
        guard let context = self.context else {return}
        
        
        let registry = NSEntityDescription.insertNewObject(forEntityName: "Toys", into: context) as! Toys
        
        registry.nome = self.nome
        registry.faixaEtaria = self.faixaEtaria
        registry.observacoes = self.observacoes
        registry.quantidade = self.quantidade
        registry.tamanho = self.tamanho
        registry.foto = self.foto
        
        do {
            try context.save()
            clear()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
}
