//
//  SideMenuCell.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 12/21/14.
//  Copyright (c) 2014 mtu. All rights reserved.
//

import Foundation
import UIKit

class SideMenuCell : UITableViewCell {
    
    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}