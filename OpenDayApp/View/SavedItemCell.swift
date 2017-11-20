//
//  SavedItemCell.swift
//  OpenDayApp
//
//  Created by Anthony Nicholas on 18/11/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import Foundation
import UIKit

class SavedItemCell: UITableViewCell{
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
