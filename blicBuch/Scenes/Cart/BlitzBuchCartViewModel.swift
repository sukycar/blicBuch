//
//  BlitzBuchCartViewModel.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 28.7.21..
//  Copyright (c) 2021 Vladimir Sukanica. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreData
import RxSwift

protocol BlitzBuchCartViewModelProtocol {
    var idArray: [String] { get set }
    var booksInCart: [Book]? { get set }
    var cartItemsNumber: Int { get set }
    var cartCountObserver: Dynamic<Int> { get set }
    var dataFetched: Dynamic<Bool> { get set }
    var cell: BookTableViewCell { get set }
    var cellIndexPath: IndexPath { get set }
    var userId: Int32 { get set }
    var disposeBag: DisposeBag { get set }
    
    func fetchBooks()
}

class BlitzBuchCartViewModel: BaseViewModel, BlitzBuchCartViewModelProtocol {
    
    // MARK: - BlitzBuchCartViewModelProtocol Vars & Lets
    
    var booksInCart: [Book]? = []
    var idArray: [String] = []
    var cartItemsNumber: Int = 0
    var cartCountObserver: Dynamic<Int> = Dynamic(0)
    var dataFetched: Dynamic<Bool> = Dynamic(false)
    var userId: Int32 = blitzBuchUserDefaults.get(.id) as? Int32 ?? 0
    var cell = BookTableViewCell()
    var cellIndexPath = IndexPath(row: 0, section: 0)
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Vars & Lets

    private let context = DataManager.shared.context

    // MARK: - Init
    
    override init() {
        super.init()
    }
    
    func fetchBooks(){
        let fetchRequest = Book.fetchRequest() as NSFetchRequest
        idArray = blitzBuchUserDefaults.get(.cartItems) as? [String] ?? [""]
        var idArraySequence = [Int32]()
        idArray.forEach { (string) in
            idArraySequence.append(Int32(string) ?? 0)
        }
        let predicate = NSPredicate(format: "id IN %@", idArraySequence)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchRequest.predicate = predicate
        do {
            self.booksInCart = try context?.fetch(fetchRequest)
            self.dataFetched.value = true
        } catch {
            self.error.value = .validation(AlertMessage(title: "", body: error.localizedDescription))
        }
        
    }
    
    func deleteBook(bookId: Int) {
        BooksService.deleteBook(bookId: bookId).subscribe { [weak self] (finished) in
            if finished {
                self?.getBooks()
            }
        } onError: { (error) in
            self.error.value = .general(AlertMessage(title: "", body: error.localizedDescription))
        } onCompleted: {
            //
        } onDisposed: {
            //
        }.disposed(by: self.disposeBag)
    }
    
    private func getBooks() {
        BooksService.getAll().subscribe { [weak self] (finished) in
            if finished {
                self?.fetchBooks()
            }
        } onError: { (error) in
            self.error.value = .general(AlertMessage(title: "", body: error.localizedDescription))
        } onCompleted: {
            //
        } onDisposed: {
            //
        }.disposed(by: self.disposeBag)
    }
}