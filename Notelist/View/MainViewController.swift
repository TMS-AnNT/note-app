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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        
    @IBAction func BtnAdd(_ sender: Any) {
      //  performSegue(withIdentifier: "ScreenAddNote", sender: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
          if let addNoteVC = storyboard.instantiateViewController(withIdentifier: "AddNoteViewController") as? AddNoteViewController {
              print("Navigating to AddNoteViewController")
              addNoteVC.onAddNote = { [weak self] title, content in
                  self?.viewModel.addNode(title: title, content: content) // Thêm ghi chú mới
              }
              addNoteVC.onUpdateNote = { [weak self] updatedNode in
                  self?.viewModel.updateNode(updatedNode) // Cập nhật ghi chú
              }
              navigationController?.pushViewController(addNoteVC, animated: true)
          } else {
              print("Failed to instantiate AddNoteViewController")
          }
    }
    // MARK: - Data Handling
    private func loadNodesFromDatabase() {
        nodes = Array(nodeManager.getAllNodes())
        collectionView.reloadData()
    }
    
    
}

extension MainViewController: MainViewModelDelegate {
    func didUpdateNodes() {
        loadNodesFromDatabase()  // Tải lại dữ liệu từ viewModel
        collectionView.reloadData()  // Làm mới giao diện
    }
}

