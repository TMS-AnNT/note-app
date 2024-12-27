//
//  MainViewModel.swift
//  Notelist
//
//  Created by cao duc tin  on 25/12/24.
//

import Combine

class MainViewModel {

    // MARK: - Properties
    private let nodeManager = NodeManager()
    private weak var delegate: MainViewModelDelegate?
    
    @Published var nodes: [NodeModelRealm] = []
    private var cancellables = Set<AnyCancellable>()
    

//    var nodes: [NodeModelRealm] = []{
//        didSet{
//            delegate?.didUpdateNodes()
//        }
//    }
    private var allNodes: [NodeModelRealm] = []
    // MARK: - Initializer
    init(){
        loadNodes()
    }
    // MARK: - Methods
    func loadNodes() {
          allNodes = Array(nodeManager.getAllNodes())
          nodes = allNodes
      }
    func addNode(title: String, content: String,color: String?) {
        let newNode = nodeManager.createNode(title: title, content: content,color: color ?? "#000000")
        nodes.append(newNode)
    }

    func updateNode(_ updatedNode: NodeModelRealm) {
        nodeManager.updateNode(id: updatedNode.id, newTitle: updatedNode.title, newContent: updatedNode.content,color: updatedNode.color)

        if let index = nodes.firstIndex(where: { $0.id == updatedNode.id }) {
            nodes[index] = updatedNode
           // delegate?.didUpdateNodes()
        }
    }

    func deleteNode(at index: Int) {
        let nodeToDelete = nodes[index]
        nodeManager.deleteNode(id: nodeToDelete.id)
        nodes.remove(at: index)
     
    }
    func performSearch(query: String) {
        // Cập nhật lại allNodes sau khi thay đổi dữ liệu
        allNodes = Array(nodeManager.getAllNodes())

        if query.isEmpty {
            nodes = allNodes
        } else {
            nodes = allNodes.filter { node in
                node.title.localizedCaseInsensitiveContains(query) ||
                node.content.localizedCaseInsensitiveContains(query)
            }
        }
        
       // delegate?.didUpdateNodes()
    }


}



