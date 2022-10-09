//
//  CollectionViewCell.swift
//  appWeatherCastByMattSwift
//
//  Created by Mac on 28.09.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeHoursLabel: UILabel!
    @IBOutlet weak var timeHoursIcon: UIImageView!
    @IBOutlet weak var tempHoursLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
