//
//  ViewController.swift
//  Notelist
//
//  Created by cao duc tin  on 23/12/24.
//

import UIKit

class ViewController: UIViewController {
  
    // Mảng chứa các NodeModel
      var nodes: [NodeModel] = [
          NodeModel(id: "1", title: "Title 1", content: "Content for title 1"),
          NodeModel(id: "2", title: "Title 2", content: "Content for title 2"),
          NodeModel(id: "3", title: "Title 3", content: "Content for title 3")
      ]
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
  
    @IBAction func CreateButton(_ sender: Any) {
        print("hello world")
        self.performSegue(withIdentifier: "Screen", sender: self)
    }
    
}




