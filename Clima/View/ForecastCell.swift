//
//  ForecastCell.swift
//  Clima
//
//  Created by ccdtruong on 1/10/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var Icon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
