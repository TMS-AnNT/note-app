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
    override static func primaryKey() -> String? {
        return "id"
    }
}