//
//  ViewController.swift
//  Notelist
//
//  Created by cao duc tin  on 23/12/24.
//

import UIKit

class ViewController: UIViewController {
  
    // Mảng chứa các NodeModel
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



import Foundation

protocol MainViewModelDelegate: AnyObject {
    func didUpdateNodes()
}

