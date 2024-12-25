//
//  MainViewController.swift
//  Notelist
//
//  Created by cao duc tin  on 23/12/24.
//
import CHTCollectionViewWaterfallLayout
import UIKit

class MainViewController: UIViewController {
    // MARK: - Properties
    var nodes: [NodeModelRealm] = []
    // MARK: - Properties
    internal var viewModel: MainViewModel!
    internal var nodeManager = NodeManager()
    
    // MARK: - Outlets
    @IBOutlet weak var ButtonAdd: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
                   viewModel = MainViewModel(delegate: self)  // Khởi tạo viewModel
        }
        setupCollectionView()
        setupButtonAdd()
        viewModel.loadNodes()
        
    }
    // MARK: - Setup Methods
    private func setupButtonAdd(){
        let size = min(ButtonAdd.frame.width, ButtonAdd.frame.height)
        ButtonAdd.frame.size = CGSize(width: size, height: size)
        
        // Bo tròn hoàn toàn
        ButtonAdd.layer.cornerRadius = size / 2
        ButtonAdd.clipsToBounds = true
        
    }
    private func setupCollectionView() {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScreenAddNote",
           let addNoteVC = segue.destination as? AddNoteViewController {
               if let selectedNode = sender as? NodeModelRealm {
                   // Edit Note
                   addNoteVC.modalPresentationStyle = .fullScreen
                   addNoteVC.existingNote = selectedNode
                   addNoteVC.onUpdateNote = { [weak self] updatedNode in
                       self?.viewModel.updateNode(updatedNode)
                   }
               } else {
                   // Add New Note
                   addNoteVC.modalPresentationStyle = .fullScreen
                   addNoteVC.onAddNote = { [weak self] title, content in
                       self?.viewModel.addNode(title: title, content: content)
                   }
               }
        }
    }
    
    @IBAction func BtnAdd(_ sender: Any) {
        performSegue(withIdentifier: "ScreenAddNote", sender: self)
    }
    // MARK: - Data Handling
    private func loadNodesFromDatabase() {
        nodes = Array(nodeManager.getAllNodes())
        collectionView.reloadData()
    }
    
    
}

extension MainViewController: MainViewModelDelegate {
    func didUpdateNodes() {
        // Cập nhật dữ liệu khi nodes thay đổi
        loadNodesFromDatabase()  // Tải lại dữ liệu từ viewModel
        collectionView.reloadData()  // Làm mới giao diện
    }
}

