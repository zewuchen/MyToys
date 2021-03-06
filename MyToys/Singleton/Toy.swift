import CoreData
import UIKit
import Foundation

class Toy{

    static let shared:Toy = Toy()

    public var faixaEtaria: String?
    public var nome: String?
    public var observacoes: String?
    public var quantidade: Int64?
    public var tamanho: String?
    public var foto: String?
    public var id: String?
    public var dateAdd: NSDate?
    public var dateLast: NSDate?

    public var brinquedos:[Toys]
    public var tamanhos:[String]
    public var faixas:[String]
    public var edit:Bool
    var context: NSManagedObjectContext?

    private init(){
        self.nome = ""
        self.observacoes = ""
        self.quantidade = 1
        self.foto = ""
        self.brinquedos = []
        self.tamanhos = ["Pequeno", "Medio", "Grande"]
        self.tamanho = self.tamanhos[0]
        self.faixas = ["Menor de 6 meses", "Maior de 1 ano", "Maior de 3 anos", "Maior de 6 anos", "Maior de 9 anos", "Maior de 12 anos"]
        self.faixaEtaria = self.faixas[0]
        self.id = UUID().uuidString
        self.dateAdd = Date() as NSDate
        self.dateLast = Date() as NSDate
        self.edit = false


        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.fetchData()
    }

    /**
    *Limpa os dados do brinquedo*
    - Parameters: Nenhum
    - Returns: Nenhum
    */
    func clear(){
        self.faixaEtaria = self.faixas[0]
        self.nome = ""
        self.observacoes = ""
        self.quantidade = 1
        self.tamanho = self.tamanhos[0]
        self.foto = ""
        self.edit = false
    }

    /**
    *Salva a foto do brinquedo pelo FileHelper e gera um UUID para o nome da imagem*
    - Parameters:
        - imagem: UIImage que contém a imagem a ser salva
    - Returns: String nome da foto do brinquedo salvo
    */
    func saveFoto(imagem:UIImage) -> String{
        let fileName = UUID().uuidString
        FileHelper.saveImage(image: imagem, nameWithoutExtension: fileName)
        return fileName
    }

    /**
    *Deleta a foto do brinquedo pelo FileHelper*
    - Parameters:
        - fileURL: caminho da imagem salva
    - Returns: Nenhum
    */
    func deleteFoto(fileURL:String?) {
        guard let fileURL = fileURL else {return}
        FileHelper.deleteImage(filePathWithoutExtension: fileURL)
    }

    /**
    *Salva as informações do brinquedo*
    - Parameters: Nenhum
    - Returns: Nenhum
    */
    func save(){
        guard let context = self.context else {return}
        guard let nome = self.nome else {return}
        guard let faixaEtaria = self.faixaEtaria else {return}
        guard var observacoes = self.observacoes else {return}
        if observacoes == "Observações"{
            observacoes = ""
        }
        guard let quantidade = self.quantidade else {return}
        guard let tamanho = self.tamanho else {return}
        guard let foto = self.foto else {return}
        self.id = UUID().uuidString
        self.dateAdd = Date() as NSDate
        self.dateLast = Date() as NSDate
        guard let id = self.id else {return}
        guard let dateAdd = self.dateAdd else {return}
        guard let dateLast = self.dateLast else {return}


        let registry = NSEntityDescription.insertNewObject(forEntityName: "Toys", into: context) as! Toys

        registry.nome = nome
        registry.faixaEtaria = faixaEtaria
        registry.observacoes = observacoes
        registry.quantidade = quantidade
        registry.tamanho = tamanho
        registry.foto = foto
        registry.id = id
        registry.dateAdd = dateAdd
        registry.dateLast = dateLast

        do {
            try context.save()
            clear()
            Notification.shared.create(id:id, nome: nome)
            print("Brinquedo cadastrado, ID: \(id), NOME:\(nome)")
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    /**
    *Puxa os dados dos brinquedos já armazenados*
    - Parameters: Nenhum
    - Returns: Nenhum
    */
    func fetchData(){
        do{
            brinquedos = try context!.fetch(Toys.fetchRequest())
            brinquedos.reverse()
        } catch{
            print(error.localizedDescription)
        }
    }

    /**
     *Puxa os dados de um brinquedo específico que já foi feito o request dos dados*
     - Parameters:
        - id: id do brinquedo
     - Returns: Nenhum
     */
    func fetchToy(id:String){
        for i in brinquedos{
            if i.id == id{
                self.nome = i.nome
                self.observacoes = i.observacoes
                self.quantidade = i.quantidade
                self.foto = i.foto
                self.tamanho = i.tamanho
                self.faixaEtaria = i.faixaEtaria
                self.id = i.id
                self.dateAdd = i.dateAdd
                self.dateLast = i.dateLast
            }
        }
    }

    /**
    *Atualiza os dados de um brinquedo específico*
    - Parameters:
        - id: id do brinquedo
    - Returns: Nenhum
    */
    func update(id: String) {
        guard let nome = self.nome else {return}
        guard let faixaEtaria = self.faixaEtaria else {return}
        guard var observacoes = self.observacoes else {return}
        if observacoes == "Observações"{
            observacoes = ""
        }
        guard let quantidade = self.quantidade else {return}
        guard let tamanho = self.tamanho else {return}
        guard let foto = self.foto else {return}
        self.dateLast = Date() as NSDate
        guard let dateLast = self.dateLast else {return}

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Toys")
        let predicate = NSPredicate(format: "id == '\(id)'")
        fetchRequest.predicate = predicate
        do {
            let object = try managedContext.fetch(fetchRequest)
            if object.count == 1 {
                let objectUpdate = object[0] as! NSManagedObject
                objectUpdate.setValue(nome, forKey: "nome")
                objectUpdate.setValue(faixaEtaria, forKey: "faixaEtaria")
                objectUpdate.setValue(observacoes, forKey: "observacoes")
                objectUpdate.setValue(quantidade, forKey: "quantidade")
                objectUpdate.setValue(tamanho, forKey: "tamanho")
                objectUpdate.setValue(foto, forKey: "foto")
                objectUpdate.setValue(dateLast, forKey: "dateLast")

                do {
                    try managedContext.save()
                    clear()
                    print("Brinquedo atualizado, ID: \(id), NOME:\(nome)")
                } catch let error as NSError {
                    print(error.code)
                }
            }
        } catch {
            print(error)
        }
    }

    /**
    *Deleta os dados de um brinquedo específico*
    - Parameters:
        - id: id do brinquedo
    - Returns: Nenhum
    */
    func delete(id:String){

//        guard let context = self.context else {return}
//
//        let objectToDelete = self.brinquedos[posicao] as NSManagedObject
//        deleteFoto(fileURL: self.brinquedos[posicao].foto)
//        context.delete(objectToDelete)
//
//        do{
//            try context.save()
//        } catch{
//            print(error.localizedDescription)
//        }

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Toys")
        let predicate = NSPredicate(format: "id == '\(id)'")
        fetchRequest.predicate = predicate
        do {
            let object = try managedContext.fetch(fetchRequest)
            if object.count == 1 {
                let objectDelete = object[0] as! NSManagedObject
                Notification.shared.delete(id: id)
                if let imagens = (objectDelete as! Toys).foto {
                    let fotos = imagens.split(separator: ";")
                    for foto in fotos {
                        deleteFoto(fileURL: String(foto))
                    }
                }
                context?.delete(objectDelete)
                print("Brinquedo deletado, ID: \(id)")
            }
        } catch {
            print(error)
        }
    }

}
