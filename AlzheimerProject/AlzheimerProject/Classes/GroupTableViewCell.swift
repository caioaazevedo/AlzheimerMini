//
//  GroupTableViewCell.swift
//  core
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 10/09/19.
//  Copyright © 2019 Pedro Paulo Feitosa Rodrigues Carneiro. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    @IBOutlet weak var imgGroup: UIImageView!
    @IBOutlet weak var labelGroup: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
