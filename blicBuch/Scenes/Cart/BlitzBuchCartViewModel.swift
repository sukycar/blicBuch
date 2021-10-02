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
import StoreKit

protocol BlitzBuchCartViewModelProtocol {
    var idArray: [String] { get set }
    var booksInCart: [Book]? { get set }
    var cartItemsNumber: Int { get set }
    var cartCountObserver: Dynamic<Int> { get set }
    var dataFetched: Dynamic<Bool> { get set }
    var cell: BookTableViewCell { get set }
    var cellIndexPath: IndexPath { get set }
    var user: UserCodable? { get set }
    var disposeBag: DisposeBag { get set }
    var models: Dynamic<[SKProduct]> { get set }
    
    func fetchBooks()
    func fetchProducts()
    func deleteBook(bookId: Int)
}

class BlitzBuchCartViewModel: BaseViewModel, BlitzBuchCartViewModelProtocol, SKProductsRequestDelegate {
    
    // MARK: - BlitzBuchCartViewModelProtocol Vars & Lets
    
    var booksInCart: [Book]? = []
    var idArray: [String] = []
    var cartItemsNumber: Int = 0
    var cartCountObserver: Dynamic<Int> = Dynamic(0)
    var dataFetched: Dynamic<Bool> = Dynamic(false)
    var user: UserCodable?
    var cell = BookTableViewCell()
    var cellIndexPath = IndexPath(row: 0, section: 0)
    var disposeBag: DisposeBag = DisposeBag()
    var models: Dynamic<[SKProduct]> = Dynamic([SKProduct]())
    
    // MARK: - Vars & Lets

    private let context = DataManager.shared.context

    // MARK: - Init
    
    override init() {
        self.user = BlitzBuchUserDefaults(userDefaults: UserDefaults.standard).getUser()
        super.init()
    }
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(BlitzBuchCart.TransportExpences.allCases.compactMap({$0.rawValue})))
        request.delegate = self
        request.start()
    }
    
    func fetchBooks(){
        let fetchRequest = Book.fetchRequest() as NSFetchRequest
        let cartItems = self.user?.cartItems
        if let cartItems = user?.cartItems, cartItems.contains(",") {
            idArray = cartItems.components(separatedBy: ",")
        } else {
            idArray = cartItems.map({[String($0)]}) ?? [""]
        }
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
    
    // MARK: - SKProductDelegate Methods
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.models.value = response.products
    }
}
