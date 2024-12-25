//
//  MainViewModel.swift
//  Notelist
//
//  Created by cao duc tin  on 25/12/24.
//



class MainViewModel {

    // MARK: - Properties
    private let nodeManager = NodeManager()
    private weak var delegate: MainViewModelDelegate?

    var nodes: [NodeModelRealm] = []

    // MARK: - Initializer
    init(delegate: MainViewModelDelegate) {
        self.delegate = delegate
    }

    // MARK: - Methods
    func loadNodes() {
        nodes = Array(nodeManager.getAllNodes())
        delegate?.didUpdateNodes()
    }

    func addNode(title: String, content: String) {
        let newNode = nodeManager.createNode(title: title, content: content)
        nodes.append(newNode)
        delegate?.didUpdateNodes()
    }

    func updateNode(_ updatedNode: NodeModelRealm) {
        nodeManager.updateNode(id: updatedNode.id, newTitle: updatedNode.title, newContent: updatedNode.content)

        if let index = nodes.firstIndex(where: { $0.id == updatedNode.id }) {
            nodes[index] = updatedNode
            delegate?.didUpdateNodes()
        }
    }

    func deleteNode(at index: Int) {
        let nodeToDelete = nodes[index]
        nodeManager.deleteNode(id: nodeToDelete.id)
        nodes.remove(at: index)
        delegate?.didUpdateNodes()
    }
}



