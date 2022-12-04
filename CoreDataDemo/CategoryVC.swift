//
//  CategoryVC.swift
//  CoreDataDemo
//
//  Created by Genusys Inc on 11/30/22.
//

import UIKit

class CategoryVC: UITableViewController {

    var isRunning = false
    override func viewDidLoad() {
        super.viewDidLoad()
        print("first",isRunning)
        testfunc()
        
        DispatchQueue.main.async {
            self.isRunning = false
        }
        print("second",isRunning)
    }

    func testfunc(){
        print("testfunc")
        isRunning = false
        for i in 0...10000{
            
        }
    }

    @IBAction func addCategoryAction(_ sender: UIBarButtonItem) {
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

  

}
