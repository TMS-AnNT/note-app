//
//  AddNoteViewController.swift
//  Notelist
//
//  Created by cao duc tin  on 24/12/24.
//

import UIKit
import RealmSwift

class AddNoteViewController: UIViewController {

    @IBOutlet weak var ColorWell: UIColorWell!
    @IBOutlet weak var TxtContent: UITextView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var BtnAdd: UIButton!
    @IBOutlet weak var UIImageBack: UIImageView!
    var onAddNote: ((String , String,String) -> Void)?
    var existingNote: NodeModelRealm?
    var onUpdateNote: ((_ updatedNote: NodeModelRealm) -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        UIImageBack.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        UIImageBack.addGestureRecognizer(tapGesture)
        // Hiển thị dữ liệu nếu đang chỉnh sửa
            if let existingNote = existingNote {
                txtTitle.text = existingNote.title
                TxtContent.text = existingNote.content
                ColorWell.selectedColor = UIColor(named: existingNote.color)
                BtnAdd.setTitle("Update", for: .normal) // Đổi tên nút để phù hợp với chế độ chỉnh sửa
            } else {
                BtnAdd.setTitle("Add", for: .normal)
            }
    }
    
    
    @IBAction func btnActionAddNote(_ sender: Any) {
        guard let title = txtTitle.text, !title.isEmpty,
                  let content = TxtContent.text, !content.isEmpty else {
                return
            }
            let selectedColor = ColorWell.selectedColor ?? UIColor.blue // Default to gray if no color is selected
            print("this is the color\(selectedColor.toHex())")
           if let existingNote = existingNote {
               // Nếu đang chỉnh sửa ghi chú
               do {
                   let realm = try Realm()
                   try realm.write {
                       existingNote.title = title
                       existingNote.content = content
                       existingNote.color = selectedColor.toHex()
                   }
                   // Gọi closure để cập nhật giao diện
                   onUpdateNote?(existingNote)
               } catch {
                   print("Error updating note: \(error.localizedDescription)")
               }
           } else {
               // Nếu thêm mới ghi chú
               onAddNote?(title, content,selectedColor.toHex())
           }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func imageTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
