//
//  BaseViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 24.2.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var isVipController : Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    /// Array of locked books id's on server.
    /// When locked, book can't be selected from other device or user
    var lockedBooks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleViews()
        self.configureTable()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func styleViews(){
    }
    
    func configureTable(){
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
