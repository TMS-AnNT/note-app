//
//  AddNoteViewController.swift
//  Notelist
//
//  Created by cao duc tin  on 24/12/24.
//

import UIKit
import RealmSwift
import AVFoundation
class AddNoteViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ColorWell: UIColorWell!
    @IBOutlet weak var TxtContent: UITextView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var BtnAdd: UIButton!
    @IBOutlet weak var UIImageBack: UIImageView!
    var onAddNote: ((String , String,String,[String]?) -> Void)?
    var audioPlayer: AVAudioPlayer?
    var viewModel: AddNoteViewModel!
    var onUpdateNote: ((_ updatedNote: NodeModelRealm) -> Void)?
    var existingNote: NodeModelRealm?
    @IBAction func btnAudioAction(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
             
             actionSheet.addAction(UIAlertAction(title: "Choose Audio", style: .default, handler: { _ in
                 let storyboard = UIStoryboard(name: "Main", bundle: nil)
                 if let audioRecordingVC = storyboard.instantiateViewController(withIdentifier: "AudioRecordingViewController") as? AudioRecordingViewController {

                     self.navigationController?.pushViewController(audioRecordingVC, animated: true)
                     audioRecordingVC.onCompleteRecording = { [weak self] in
                                  self?.viewModel.fetchAudioFiles()
                                  self?.tableView.reloadData()
                              }
                     audioRecordingVC.onFinishRecording = { [weak self] fileName in
                         print("this is file name\(fileName)")
                         self?.viewModel.AddFileNameTempt(fileName)
                         self?.viewModel.GetFileName()
                       //  self?.viewModel.GetURlTempt()
                     }
                     
                                }
                 
             }))
             
             actionSheet.addAction(UIAlertAction(title: "Choose Image", style: .default, handler: { _ in
                 self.chooseImage()
             }))
             
             actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
             
             present(actionSheet, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.onFetchAudioFiles = { [weak self] in
            self?.tableView.reloadData()
        }
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        viewModel = AddNoteViewModel(existingNote: existingNote)
        viewModel.onFetchAudioFiles = { [weak self] in
            self?.tableView.reloadData() // Reload table with new audio files
        }
        
        // Setup initial UI based on existingNote
        if let existingNote = viewModel.existingNote {
            txtTitle.text = existingNote.title
            TxtContent.text = existingNote.content
            ColorWell.selectedColor = UIColor(named: existingNote.color)
           
        }
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    @IBAction func btnActionAddNote(_ sender: Any) {
        guard let title = txtTitle.text, !title.isEmpty,
                         let content = TxtContent.text, !content.isEmpty else {
                       return
                   }
                   let selectedColor = ColorWell.selectedColor ?? UIColor.yellow
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
                      onAddNote?(title, content,selectedColor.toHex(), viewModel.getAudioFileTemp())
                  }
               navigationController?.popViewController(animated: true)

    }

    @objc func imageTapped() {
        navigationController?.popViewController(animated: true)
    }
    // Hàm xử lý khi chọn "Image"
    func chooseImage() {
        // Hiển thị UIImagePickerController để chọn hình ảnh
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image"] // Chỉ chọn hình ảnh
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func configUI(){
        UIImageBack.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        UIImageBack.addGestureRecognizer(tapGesture)
    }
 
}
extension AddNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            print("Selected image: \(selectedImage)")
            // Handle image (save to Realm or display it)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}




extension AddNoteViewController: UITableViewDelegate, UITableViewDataSource{
    // MARK: UITableView DataSource Methods

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.audioFiles.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath) as! AudioTableViewCell
            let fileName = viewModel.audioFiles[indexPath.row].lastPathComponent

            cell.configUI(with: fileName)
            return cell
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFileURL = viewModel.audioFiles[indexPath.row]
        print("this covert tệp tồn tại \(selectedFileURL.path)")
        let absoluteString = selectedFileURL.absoluteString
        print("convert it to String\(absoluteString)")
        print("convert it to URL\(URL(string: absoluteString))")
//        let url = URL(fileURLWithPath: filePath.replacingOccurrences(of: "file:/", with: "file:///"))
//        print("this is url change from url to filePath\(url)")
     
        print("Selected file URL: \(selectedFileURL)")  // In ra để kiểm tra URL
        
        do {
            // Check if audio player is already playing, stop it if necessary
            if audioPlayer?.isPlaying == true {
                audioPlayer?.stop()
            }
            
            if FileManager.default.fileExists(atPath: selectedFileURL.path) {
                print("Tệp tồn tại.\(selectedFileURL.path)")
            } else {
                print("Tệp không tồn tại tại đường dẫn: \(selectedFileURL.path)")
            }
            audioPlayer = try AVAudioPlayer(contentsOf: selectedFileURL)
            audioPlayer?.play()
            
            // Optionally, show a UIAlertController to pause/resume audio or display options.
            let actionSheet = UIAlertController(title: "Audio Options", message: nil, preferredStyle: .actionSheet)
            
            // Pause/Resume action
            actionSheet.addAction(UIAlertAction(title: "Pause", style: .default, handler: { _ in
                self.audioPlayer?.pause()
            }))
            
            // Delete option
            actionSheet.addAction(UIAlertAction(title: "Delete Audio", style: .destructive, handler: { _ in
                self.viewModel.deleteAudioFile(at: indexPath.row)
                tableView.deselectRow(at: indexPath, animated: true)
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(actionSheet, animated: true, completion: nil)
        } catch let error as NSError {
            print("Error playing audio: \(error.localizedDescription), code: \(error.code)")
        }
    }
}
