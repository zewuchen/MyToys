//
//  FileHelper.swift
//  MyToys
//
//  Created by Zewu Chen on 02/08/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//

import Foundation
import UIKit

class FileHelper{
    private static let fileManager:FileManager = FileManager()
    
    public static func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    public static func saveImage(image:UIImage, nameWithoutExtension:String){
        
        if let data = image.jpegData(compressionQuality: 1.0) {
            let filename = getDocumentsDirectory().appendingPathComponent("\(nameWithoutExtension).jpg")
            do{
                try data.write(to: filename)
                print("Foto salva")
            }
            catch{
                print("Erro ao salvar a foto:", error)
            }
        }
    }
    
    public static func getFile(filePathWithoutExtension:String) -> String?{
        let imagePath:URL = getDocumentsDirectory().appendingPathComponent("\(filePathWithoutExtension).jpg")
        if fileManager.fileExists(atPath: imagePath.relativePath){
            return imagePath.relativePath
        }
        else{
            return nil
        }
    }
    
    public static func deleteImage(filePathWithoutExtension:String){
        do{
            let imagePath:URL = getDocumentsDirectory().appendingPathComponent("\(filePathWithoutExtension).jpg")
            if fileManager.fileExists(atPath: imagePath.relativePath){
                try fileManager.removeItem(at: imagePath)
                print("Foto excluída")
            }
        }
        catch{
            print("Erro ao excluir a foto:", error)
        }
    }
}
