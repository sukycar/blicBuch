//
//  BlitzBuchCartViewController.swift
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
import RxSwift

protocol BlitzBuchCartVCDelegate: AnyObject {
    func reloadCartCounter()
}

protocol BlitzBuchCartViewControllerProtocol: AnyObject {
    
}

class BlitzBuchCartViewController: BaseViewController, BlitzBuchCartViewControllerProtocol {
    
    // MARK: - Vars & Lets
    
    private var customView: BlitzBuchCartView! {
        loadViewIfNeeded()
        return view as? BlitzBuchCartView
    }
    var viewModel: (BaseViewModel & BlitzBuchCartViewModelProtocol)?
    weak var delegate: BlitzBuchCartVCDelegate?
    
    // MARK: - Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Cart", comment: "")
        self.customView.setup(target: self,
                              tableViewDelegate: self,
                              tableViewDataSource: self)
        if let viewModel = viewModel {
            viewModel.fetchBooks()
        }
        self.bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        self.delegate?.reloadCartCounter()
    }
    // MARK: - Private methods
    
    private func bindViewModel() {
        self.viewModel?.error.bind({ [weak self] in
            if let error = $0 {
                self?.getAlert(errorString: error.localizedDescription, errorColor: .orange)
            }
        })
        self.viewModel?.dataFetched.bind({ [weak self] _ in
            self?.view.stopActivityIndicator()
            self?.customView.tableView.reloadData()
        })
    }
    
    private func connectCellAction(cell: BookTableViewCell) {
        self.view.startActivityIndicator()
        let book = self.viewModel?.booksInCart?[self.viewModel?.cellIndexPath.row ?? 0]
        self.viewModel?.cartItemsNumber -= 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
            guard let id = blitzBuchUserDefaults.get(.id) as? Int32 else {return}
            UsersService.checkForAvailableBooks(id).subscribe {(vip, regular) in
                let vip = vip
                let regular = regular
                let id = blitzBuchUserDefaults.get(.id)
                
                //function for updating number of available books
                let vipStatus = book?.vip
                if vipStatus == true {
                    DispatchQueue.main.async {
                        self.updateVipBooksNumber(removeBooks: false, numberOfBooks: 1, disposeBag: cell.disposeBag)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.updateBooksNumber(removeBooks: false, numberOfBooks: 1, disposeBag: cell.disposeBag)
                    }
                }
            } onError: { (error) in
                self.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
            } onCompleted: {
                //
            } onDisposed: {
                //
            }.disposed(by: cell.disposeBag)
            BooksService.lockBook(bookId: book?.id ?? 0, lockStatus: .unlocked).subscribe { (subscribed) in
                //
            } onError: { (error) in
                self.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
            } onCompleted: {
                //
            }.disposed(by: cell.disposeBag)
        }
        
        self.viewModel?.idArray.forEach({ (bookId) in
            if bookId == String(book?.id ?? 0){
                self.viewModel?.idArray.removeAll(where: { (string) -> Bool in
                    string == bookId
                })
                _ = blitzBuchUserDefaults.set(.cartItems, value: self.viewModel?.idArray)
                self.viewModel?.fetchBooks()
            }
        })
        UsersService.updateCartBooks(userId: self.viewModel?.userId ?? 0, bookIDs: self.viewModel?.idArray ?? [""]).subscribe { (updated) in
            //
            DispatchQueue.main.async {
                self.customView.tableView.reloadData()
            }
            self.view.stopActivityIndicator()
            
        } onError: { (error) in
            self.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
        } onCompleted: {
            //
        }.disposed(by: cell.disposeBag)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension BlitzBuchCartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.viewModel?.booksInCart?.count ?? 1
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if self.viewModel?.booksInCart?.count ?? 0 > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookTableViewCell.self), for: indexPath) as! BookTableViewCell
                let book = self.viewModel?.booksInCart?[indexPath.row]
                cell.set(with: book ?? Book(), inVipController: false)
                cell.cellDelegate = self
                cell.orderButton.setImage(UIImage(named: "img_remove"), for: .normal)
                cell.orderButton.translatesAutoresizingMaskIntoConstraints = false
                cell.orderButton.imageEdgeInsets = UIEdgeInsets(top: 2.5, left: 2, bottom: 2.5, right: 2)
                cell.orderButton.clipsToBounds = true
                cell.orderButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
                cell.orderButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
                cell.orderButton.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -20).isActive = true
                cell.orderButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -20).isActive = true
//                cell.orderButton.rx.tap.subscribe (onNext: {[weak self] in
//                    self?.view.startActivityIndicator()
//                    self?.viewModel?.cartItemsNumber -= 1
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
//                        guard let id = blitzBuchUserDefaults.get(.id) as? Int32 else {return}
//                        UsersService.checkForAvailableBooks(id).subscribe {(vip, regular) in
//                            let vip = vip
//                            let regular = regular
//                            let id = blitzBuchUserDefaults.get(.id)
//
//                            //function for updating number of available books
//                            let vipStatus = book?.vip
//                            if vipStatus == true {
//                                DispatchQueue.main.async {
//                                    self?.updateVipBooksNumber(removeBooks: false, numberOfBooks: 1, disposeBag: cell.disposeBag)
//                                }
//                            } else {
//                                DispatchQueue.main.async {
//                                    self?.updateBooksNumber(removeBooks: false, numberOfBooks: 1, disposeBag: cell.disposeBag)
//                                }
//                            }
//                        } onError: { (error) in
//                            self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
//                        } onCompleted: {
//                            //
//                        } onDisposed: {
//                            //
//                        }.disposed(by: cell.disposeBag)
//                        BooksService.lockBook(bookId: book?.id ?? 0, lockStatus: .unlocked).subscribe { (subscribed) in
//                            //
//                        } onError: { (error) in
//                            self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
//                        } onCompleted: {
//                            //
//                        }.disposed(by: cell.disposeBag)
//                    }
//
//                    self?.viewModel?.idArray.forEach({ (bookId) in
//                        if bookId == String(book?.id ?? 0){
//                            self?.viewModel?.idArray.removeAll(where: { (string) -> Bool in
//                                string == bookId
//                            })
//                            _ = blitzBuchUserDefaults.set(.cartItems, value: self?.viewModel?.idArray)
//                            self?.viewModel?.fetchBooks()
//                        }
//                    })
//                    UsersService.updateCartBooks(userId: self?.viewModel?.userId ?? 0, bookIDs: self?.viewModel?.idArray ?? [""]).subscribe { (updated) in
//                        //
//                        DispatchQueue.main.async {
//                            tableView.reloadData()
//                        }
//                        self?.view.stopActivityIndicator()
//
//                    } onError: { (error) in
//                        self?.getAlert(errorString: error.localizedDescription, errorColor: Colors.orange)
//                    } onCompleted: {
//                        //
//                    }.disposed(by: cell.disposeBag)
//
//                }).disposed(by: cell.disposeBag)
                self.viewModel?.cell = cell
                return cell
            } else {
                return UITableViewCell()
            }
        } else if indexPath.section == 1 {
            if self.viewModel?.booksInCart?.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: (String(describing: EmptyTableViewCell.self)), for: indexPath) as! EmptyTableViewCell
                cell.set("No items in cart".localized())
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OrderTableViewCell.self), for: indexPath) as! OrderTableViewCell
            cell.orderButton.rx.tap.subscribe(onNext: {[weak self] in
                guard let strongSelf = self else {return}
                let alert = strongSelf.alertService.get(with: .orderBooks)
                strongSelf.present(alert, animated: true, completion: nil)
            }).disposed(by: self.viewModel?.disposeBag ?? DisposeBag())
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && self.viewModel?.booksInCart?.count == 0 {
            return self.view.frame.size.height
        }
        return tableView.estimatedRowHeight
    }
}

extension BlitzBuchCartViewController {
    class func get() -> BlitzBuchCartViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BlitzBuchCartViewController") as! BlitzBuchCartViewController
        vc.viewModel = BlitzBuchCartViewModel()
//        vc.view.startActivityIndicator()
        return vc
    }
}

extension BlitzBuchCartViewController: AlertMe {
    func onLoggedOutClick() {
        let alertVC = self.alertService.alert()
        self.present(alertVC, animated: true)
    }
    
    func onClick() {
        if let viewModel = self.viewModel {
            self.connectCellAction(cell: viewModel.cell)
        }
    }
}

