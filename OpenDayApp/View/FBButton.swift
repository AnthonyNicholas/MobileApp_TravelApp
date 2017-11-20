//
//  FBButton.swift
//  OpenDayApp
//
//  Created by Anthony Nicholas on 17/11/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit

class FBButton: FBSDKLoginButton{
    
    init(view: UIView) {
        super.init(frame:  CGRect(x: 16, y: 500, width: view.frame.width - 32 , height: 43))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
