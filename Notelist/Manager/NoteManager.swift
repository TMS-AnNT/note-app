//
//  NoteManager.swift
//  Notelist
//
//  Created by cao duc tin  on 24/12/24.
//

import UIKit
import RealmSwift

class NodeManager {

    // Realm instance
    private let realm = try! Realm()

    // MARK: - Create Node
    func createNode(title: String, content: String) -> NodeModelRealm {
        let node = NodeModelRealm()
        node.title = title
        node.content = content
        
        // Add to Realm
        do {
            try realm.write {
                realm.add(node)
            }
            print("Node created successfully")
        } catch {
            print("Error creating node: \(error.localizedDescription)")
        }
        
        return node
    }

    // MARK: - Fetch All Nodes
    func getAllNodes() -> Results<NodeModelRealm> {
        return realm.objects(NodeModelRealm.self)
    }

    // MARK: - Fetch Node by ID
    func getNodeById(id: String) -> NodeModelRealm? {
        return realm.object(ofType: NodeModelRealm.self, forPrimaryKey: id)
    }

    // MARK: - Update Node
    func updateNode(id: String, newTitle: String, newContent: String) {
        guard let node = getNodeById(id: id) else {
            print("Node with ID \(id) not found")
            return
        }

        do {
            try realm.write {
                node.title = newTitle
                node.content = newContent
            }
            print("Node updated successfully")
        } catch {
            print("Error updating node: \(error.localizedDescription)")
        }
    }

    // MARK: - Delete Node
    func deleteNode(id: String) {
        guard let node = getNodeById(id: id) else {
            print("Node with ID \(id) not found")
            return
        }

        do {
            try realm.write {
                realm.delete(node)
            }
            print("Node deleted successfully")
        } catch {
            print("Error deleting node: \(error.localizedDescription)")
        }
    }

    // MARK: - Delete All Nodes
    func deleteAllNodes() {
        let allNodes = getAllNodes()
        do {
            try realm.write {
                realm.delete(allNodes)
            }
            print("All nodes deleted successfully")
        } catch {
            print("Error deleting all nodes: \(error.localizedDescription)")
        }
    }
}


