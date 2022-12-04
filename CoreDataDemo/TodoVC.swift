//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Genusys Inc on 11/30/22.
//

import UIKit
import CoreData

class TodoVC: UIViewController {

    private let tableView : UITableView = {
        let tble = UITableView()
        tble.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tble
    }()
    private var itemArray = [Item]()
    
    private var defaults = UserDefaults.standard
//
//    let dataFilePath  = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("Iems.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let itemSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        return searchBar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(itemSearchBar)
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        itemSearchBar.delegate = self
        
        loadItems()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        itemSearchBar.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: 50)
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 50, width: view.frame.size.width, height: view.frame.size.height - 50)
    }

    @IBAction func AddTodoAction(_ sender: UIBarButtonItem) {
        var textField  = UITextField()
        let alert = UIAlertController(title: "Add New todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){ action in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let item = Item(context: context)
            item.title = textField.text!
            item.done = false
            self.itemArray.append(item)
            self.saveItems()
          
        }
        alert.addTextField{aletTextField in
            aletTextField.placeholder = "Create new item"
            textField = aletTextField
            
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    
    }
    
    func saveItems(){
        do{
            try context.save()

        }catch{
            print("error saving in coredata", error.localizedDescription)
        }
        tableView.reloadData()

    }
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()){
        
        do{
          itemArray = try context.fetch(request)
        }catch{
            print("error fetching todo list",error.localizedDescription)
        }
        tableView.reloadData()
    
    }
    
//    func saveItems(){
//        let encoder = PropertyListEncoder()
//        do{
//            let data = try encoder.encode(itemArray)
//            try data.write(to:dataFilePath!)
//        }catch{
//            print(error)
//        }
//        tableView.reloadData()
//    }
//    func loadItems(){
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do{
//                itemArray = try decoder.decode([Item].self, from: data)
//                tableView.reloadData()
//
//            }catch{
//                print(error)
//            }
//        }
//    }
}


extension TodoVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        self.saveItems()
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

    }
    
    
}

extension TodoVC : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [ NSSortDescriptor(key:"title", ascending: true)]
        loadItems(with: request)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
