//
//  mainTableViewCell.swift
//  TravelLocationApp
//
//  Created by Anthony Nicholas on 13/10/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import UIKit

class mainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeTitle: UITextField!
    @IBOutlet weak var placeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
}
