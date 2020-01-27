//
//  Notification.swift
//  MyToys
//
//  Created by Zewu Chen on 24/07/19.
//  Copyright © 2019 Zewu Chen. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class Notification:NSObject,UNUserNotificationCenterDelegate{

    static let shared:Notification = Notification()

    private override init(){}

    /**
    *Cria uma notificação do brinquedo que acabou de se criar, com um intervalo de 1 mês*
    - Parameters:
        - id: id do brinquedo
        - nome: nome do brinquedo
    - Returns: Nenhum
    */
    func create(id:String, nome:String){
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION", title: "OK", options: [.foreground])

        let meetingInviteCategory =
            UNNotificationCategory(identifier: "OPTIONS",
                                   actions: [acceptAction],
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   options: .customDismissAction)

        //Cria a notificação fora
        let content = UNMutableNotificationContent()

        //Título
        content.title = "Lembra deste brinquedo?"
        //Descrição
        content.body = "Já faz um tempo que você não vê este brinquedo: \n \(nome)\nQue tal colocar para doação?"
        //Som
        content.sound = UNNotificationSound.default
        //Switch badge
        content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        //Trigger
        let data1 = Date()
        guard let data2 = Calendar.current.date(byAdding: .month, value: 1, to: Date()) else {return}
        let intervalo = data2.timeIntervalSince(data1)
            //Se quiser repetir a trigger, precisa ser mais de 60 segundos
        //Ordem aleatória
        let temp = Double.random(in: 1000 ..< 10000)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: intervalo-temp, repeats: true)

        content.categoryIdentifier = "OPTIONS"
        //Request
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.setNotificationCategories([meetingInviteCategory])
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {

                //Adiciona a notificação
                let center = UNUserNotificationCenter.current()
                center.add(request) { (error : Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    print("Notificação cadastrada, ID: \(id), NOME: \(nome)")
                }

            } else {
                print("Impossível mandar notificação - permissão negada")
            }
        }
    }

    /**
    *Deleta e cria uma nova notificação do brinquedo que acabou de ser atualizado*
    - Parameters:
        - id: id do brinquedo
        - nome: nome do brinquedo
    - Returns: Nenhum
    */
    func update(id:String, nome:String){
        do {
            delete(id: id)
            create(id: id, nome: nome)
        } catch{
            print(error.localizedDescription)
        }
    }

    /**
    *Deleta a notificação do brinquedo que acabou de ser excluído*
    - Parameters:
        - id: id do brinquedo
    - Returns: Nenhum
    */
    func delete(id:String){
        do {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.delegate = self
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
            print("Notificação deletada, ID: \(id)")
        } catch{
            print(error.localizedDescription)
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        // Perform the task associated with the action.
        switch response.actionIdentifier {
        case "ACCEPT_ACTION":
            break

        default:
            break
        }

        // Always call the completion handler when done.
        completionHandler()
    }
}
