//
//  SalesTaxItemCell.swift
//  SalesTaxUSA
//
//  Created by Nagarjuna Madamanchi on 08/05/2019.
//  Copyright © 2019 Nagarjuna Madamanchi Ltd. All rights reserved.
//

import UIKit

class SalesTaxItemCell: UITableViewCell {

    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var unitprice: UILabel!
    @IBOutlet weak var totalprice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
