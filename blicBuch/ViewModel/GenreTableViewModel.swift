//
//  GenreTableViewModel.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 23.2.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class GenreTableViewModel {
    
    var books = [CustomCellViewModel]()
    var genre : Book.Genre?
    var lockedBooks : [String]?
    
    init(genre : Book.Genre) {
        self.genre = genre
        self.fetchGenreBooks()
    }
    
    
    func fetchGenreBooks(){
        let context = DataManager.shared.context
        let fetchRequest = Book.fetchRequest() as NSFetchRequest
        if let genre = genre {
            let genreString = genre.title
        let predicate = NSPredicate(format: "genre == %@", genreString)
        fetchRequest.predicate = predicate
        do {
            self.books = try context?.fetch(fetchRequest).map({_ in return CustomCellViewModel(book: Book(), inVipController: false)}) as! [CustomCellViewModel]
        } catch let err as NSError {
            print(err.debugDescription)
        }
        }
        
    }
    
}