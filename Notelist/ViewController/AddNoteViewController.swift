//
//  AddNoteViewController.swift
//  Notelist
//
//  Created by cao duc tin  on 24/12/24.
//

import UIKit

class AddNoteViewController: UIViewController {

    @IBOutlet weak var TxtContent: UITextView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var BtnAdd: UIButton!
    @IBOutlet weak var UIImageBack: UIImageView!
    var onAddNote: ((String , String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        UIImageBack.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        UIImageBack.addGestureRecognizer(tapGesture)
    }
    
    
    @IBAction func btnActionAddNote(_ sender: Any) {
        guard let title = txtTitle.text, !title.isEmpty,
              let content = TxtContent.text, !content.isEmpty else {
            return
        }

        let newNote = NodeModel(id: UUID().uuidString, title: title, content: content)
        // Gọi closure để trả lại dữ liệu về MainViewController
        onAddNote?(title, content)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imageTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
