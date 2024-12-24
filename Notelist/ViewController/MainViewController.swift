//
//  MainViewController.swift
//  Notelist
//
//  Created by cao duc tin  on 23/12/24.
//
import CHTCollectionViewWaterfallLayout
import UIKit

class MainViewController: UIViewController {

    var nodes: [NodeModelRealm] = [] // Dùng NodeModelRealm thay cho NodeModel
    private let nodeManager = NodeManager()
    
    @IBOutlet weak var ButtonAdd: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Khởi tạo CHTCollectionViewWaterfallLayout
        setupCollectionView()
        //collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        let size = min(ButtonAdd.frame.width, ButtonAdd.frame.height)
        ButtonAdd.frame.size = CGSize(width: size, height: size)
        
        // Bo tròn hoàn toàn
        ButtonAdd.layer.cornerRadius = size / 2
        ButtonAdd.clipsToBounds = true
        loadNodesFromDatabase()
        
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


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScreenAddNote" {
            if let addNoteVC = segue.destination as? AddNoteViewController {
                // Thiết lập closure để nhận dữ liệu từ AddNoteViewController
                addNoteVC.modalPresentationStyle = .fullScreen
                addNoteVC.onAddNote = { [weak self] title, content in
                             guard let self = self else { return }
                    let newNode = self.nodeManager.createNode(title: title, content: content)
                             self.nodes.append(newNode)
                             self.collectionView.reloadData()
                         }
            }
        }
    }

    @IBAction func BtnAdd(_ sender: Any) {
        performSegue(withIdentifier: "ScreenAddNote", sender: self)
    }
    private func loadNodesFromDatabase() {
           nodes = Array(nodeManager.getAllNodes())
           collectionView.reloadData()
       }

    
}
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCollectionViewCell", for: indexPath) as! NoteCollectionViewCell
        cell.layer.cornerRadius = 8  // Góc bo tròn cho cell
        
        // Truyền dữ liệu từ model vào cell
        let node = nodes[indexPath.row]
        cell.setup(with: node)
        
        return cell
    }
}

extension MainViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 10 // Chia làm 2 cột
        
        
        let content = nodes[indexPath.row].content
        let title = nodes[indexPath.row].title
        
        let contentHeight = heightForText(content, width: width)
        let titleHeight = heightForText(title, width: width)
        
        
        let totalHeight = contentHeight + titleHeight + 50
        return CGSize(width: width, height: totalHeight)
    }
    
    //caculate the height
    private func heightForText(_ text: String, width: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 16) // Đặt font chữ tương ứng
        let attributes = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        // Tính bounding box
        let boundingBox = attributedText.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            context: nil
        )
        
        return ceil(boundingBox.height) // Làm tròn chiều cao
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(nodes[indexPath.row].title)
    }
}
