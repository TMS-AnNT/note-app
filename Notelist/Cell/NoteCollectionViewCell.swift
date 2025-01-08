//
//  NoteCollectionViewCell.swift
//  Notelist
//
//  Created by cao duc tin  on 23/12/24.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ContentLabel: UILabel!
    func setup(with note: NodeModelRealm) {
        titleLabel.text = note.title
        ContentLabel.text = note.content
        ContentLabel.numberOfLines = 8
        titleLabel.numberOfLines = 0
      
        let color = UIColor(hex: note.color)
        self.backgroundColor = .blue
        self.contentView.backgroundColor = color
       }
}
