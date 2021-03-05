//
//  VipViewControllerViewModel.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 4.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import CoreData

class VipViewControllerViewModel {
    
    var vipBooks : [Book]?
    let titleText = "VIP"
    
    init(){
        self.getVipBooks()
    }
    
    func getVipBooks(){
        let fetchRequest = Book.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "vip == true")
        fetchRequest.predicate = predicate
        do {
            vipBooks = try DataManager.shared.context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
