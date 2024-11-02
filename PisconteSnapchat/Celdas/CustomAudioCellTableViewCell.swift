//
//  CustomAudioCellTableViewCell.swift
//  PisconteSnapchat
//
//  Created by Santiago Pisconte  on 2/11/24.
//

import UIKit

class CustomAudioCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var tableViewTitulo: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var tableViewFrom: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

