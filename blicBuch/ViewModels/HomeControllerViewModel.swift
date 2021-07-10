//
//  HomeControllerViewModel.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 11.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import CoreData

class HomeControllerViewModel {
    
    var context = DataManager.shared.context
    var homeBooks : [Book]?
    
    init(){
        self.fetchLatestBooks()
    }
    
    func fetchLatestBooks(){
        let fetchRequest = Book.fetchRequest() as NSFetchRequest
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        fetchRequest.fetchLimit = 5
        do {
            self.homeBooks = try context?.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
}
