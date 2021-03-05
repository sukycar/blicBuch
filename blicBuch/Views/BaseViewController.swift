//
//  BaseViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 24.2.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var isVipController : Bool = false
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
