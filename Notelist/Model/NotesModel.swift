//
//  NotesModel.swift
//  Notelist
//
//  Created by cao duc tin  on 23/12/24.
//

import Foundation
import RealmSwift

class NodeModelRealm: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var color: String = "#000000"
//    @objc dynamic var audioFilePath: String?
    // Use List<String> to store an array of audio file paths
    let audioFilePaths = List<String>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
