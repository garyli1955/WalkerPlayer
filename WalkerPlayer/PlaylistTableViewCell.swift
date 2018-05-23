//
//  PlaylistTableViewCell.swift
//  WalkerPlayer
//
//  Created by user on 2/27/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("awakeFromNib()")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("setSelected()")
        // Configure the view for the selected state
    }

}
