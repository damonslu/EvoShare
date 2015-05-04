//
//  CountryCell.swift
//  EvoShareSwift
//
//  Created by Ilya Vlasov on 3/2/15.
//  Copyright (c) 2015 mtu. All rights reserved.
//

import Foundation
import UIKit

class CountryCell: UITableViewCell {
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
