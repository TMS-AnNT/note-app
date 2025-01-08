//
//  AudioTableViewCell.swift
//  Notelist
//
//  Created by cao duc tin  on 8/1/25.
//

import UIKit

class AudioTableViewCell: UITableViewCell {

    @IBOutlet weak var AudioLabel: UILabel!
    @IBOutlet weak var ImageUIView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configUI(with fileName: String){
        AudioLabel.text = fileName
    }

}
