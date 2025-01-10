//
//  MainViewModel.swift
//  Notelist
//
//  Created by cao duc tin  on 25/12/24.
//

import Combine
import RealmSwift

class MainViewModel {
    
    // MARK: - Properties
    private let nodeManager = NodeManager()
    private weak var delegate: MainViewModelDelegate?
    
    @Published var nodes: [NodeModelRealm] = []
    private var cancellables = Set<AnyCancellable>()
    
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
    func addNode(title: String, content: String,color: String?, audioFiles: [String]) {
        let newNode = nodeManager.createNode(title: title, content: content,color: color ?? "#000000",audio: audioFiles)
        nodes.append(newNode)
        
    }
    func updateNode(_ id: String, _ title: String, _ content: String, _ color: String?, _ audioFileArr: [String]) {
        
        nodeManager.updateNode(id: id, newTitle: title, newContent: content, color: color ?? "#B00000", newAudioFile: audioFileArr)
        do {
            let realm = try Realm()
            
            try realm.write {
                
                if let index = nodes.firstIndex(where: { $0.id == id }) {
                    var updatedNode = nodes[index]
                    updatedNode.title = title
                    updatedNode.content = content
                    updatedNode.color = color ?? "#B00000"
                    
                    // Clear existing audio files and add the new ones
                    updatedNode.audioFilePaths.removeAll()
                    updatedNode.audioFilePaths.append(objectsIn: audioFileArr)
                    
                    // Update the node in the array
                    nodes[index] = updatedNode
                } // Use `.modified` to update existing nodes in Realm
            }
        } catch {
        print("Error updating node: \(error.localizedDescription)")
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
    }
    
    func getAllNote(){
        debugPrint(nodes)
    }
    
    
}



