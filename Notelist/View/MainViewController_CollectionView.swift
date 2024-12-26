//
//  MainViewController_CollectionView.swift
//  Notelist
//
//  Created by cao duc tin  on 25/12/24.
//

// MainViewController+CollectionView.swift
import UIKit
import CHTCollectionViewWaterfallLayout
extension MainViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.nodes.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCollectionViewCell", for: indexPath) as! NoteCollectionViewCell
            cell.layer.cornerRadius = 8
            let node = viewModel.nodes[indexPath.row]
            cell.setup(with: node)
            return cell
        }
    }

extension MainViewController: CHTCollectionViewDelegateWaterfallLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width / 2 - 10
            let content = nodes[indexPath.row].content
            let title = nodes[indexPath.row].title
            let contentHeight = heightForText(content, width: width)
            let titleHeight = heightForText(title, width: width)
            let totalHeight = contentHeight + titleHeight + 50
            return CGSize(width: width, height: totalHeight)
        }

        private func heightForText(_ text: String, width: CGFloat) -> CGFloat {
            let font = UIFont.systemFont(ofSize: 16)
            let attributes = [NSAttributedString.Key.font: font]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            let boundingBox = attributedText.boundingRect(
                with: CGSize(width: width, height: .greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                context: nil
            )
            return ceil(boundingBox.height)
        }
    }

extension MainViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedNode = nodes[indexPath.row]
            
            // Khởi tạo AddNoteViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let addNoteVC = storyboard.instantiateViewController(withIdentifier: "AddNoteViewController") as? AddNoteViewController {
                // Chuyển dữ liệu cho AddNoteViewController
                addNoteVC.existingNote = selectedNode
                addNoteVC.modalPresentationStyle = .fullScreen  // Nếu bạn muốn hiển thị full screen
                
      
                addNoteVC.onUpdateNote = { [weak self] updatedNode in
                    self?.viewModel.updateNode(updatedNode) // Cập nhật dữ liệu
                }

                navigationController?.pushViewController(addNoteVC, animated: true)
            }

        }

        func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
//                self?.deleteNode(at: indexPath)
                self?.viewModel.deleteNode(at: indexPath.row)
            }
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                UIMenu(title: "", children: [deleteAction])
            }
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
