//
//  MainViewController.swift
//  Notelist
//
//  Created by cao duc tin  on 23/12/24.
//
import CHTCollectionViewWaterfallLayout
import UIKit
import Combine

class MainViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var SearchBarBtn: UIButton!
    var nodes: [NodeModelRealm] = []
    // MARK: - Properties
    internal var viewModel: MainViewModel = MainViewModel()
    internal var nodeManager = NodeManager()
    
    internal var searchTextField: UITextField!
    internal var blurEffectView: UIVisualEffectView!
    // MARK: - Outlets
    @IBOutlet weak var ButtonAdd: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Các thuộc tính Combine
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    @IBAction func btnSearchAction(_ sender: UIButton) {
        
        // Toggle searchTextField visibility and blur effect
        if searchTextField.isHidden {
            searchTextField.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.blurEffectView.alpha = 0.5
            }
        } else {
            searchTextField.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.blurEffectView.alpha = 0.0
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureUI()
        setupCollectionView()
        addTapGestureToDismissSearch()
        searchTextField.delegate = self
        viewModel.$nodes
                  .sink { [weak self] updatedNodes in
                      self?.nodes = updatedNodes  // Cập nhật danh sách nodes từ viewModel
                      self?.collectionView.reloadData()  // Làm mới giao diện
                  }
                  .store(in: &cancellables)

    }
    // MARK: - UI Setup
       private func configureUI() {
           setupButtonAdd()
           setupCollectionView()
           setupSearchTextField()
           setupBlurEffectView()
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
    
    // Add tap gesture recognizer to dismiss search when tapping outside
    @IBAction func BtnAdd(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addNoteVC = storyboard.instantiateViewController(withIdentifier: "AddNoteViewController") as? AddNoteViewController {
            print("Navigating to AddNoteViewController")
            addNoteVC.onAddNote = { [weak self] title, content , color in
                self?.viewModel.addNode(title: title, content: content,color: color) // Thêm ghi chú mới
            }
            addNoteVC.onUpdateNote = { [weak self] updatedNode in
                self?.viewModel.updateNode(updatedNode) // Cập nhật ghi chú
            }
            navigationController?.pushViewController(addNoteVC, animated: true)
        } else {
            print("Failed to instantiate AddNoteViewController")
        }
    }
}

extension MainViewController: MainViewModelDelegate {
    func didUpdateNodes() {
       // Tải lại dữ liệu từ viewModel
        collectionView.reloadData()  // Làm mới giao diện
    }
}


extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        viewModel.performSearch(query: updatedText) // Gọi ViewModel tìm kiếm
        return true

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // Đóng bàn phím khi nhấn "Return"
        return true
    }
}
