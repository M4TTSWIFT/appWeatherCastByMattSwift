//
//  SearchTableViewCell.swift
//  appWeatherCastByMattSwift
//
//  Created by Mac on 09.10.2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellLabel.text = nil
    }
    
    func setCells(city: String, country: String?, index: IndexPath) {
        self.cellLabel.text = "\(city), \(country ?? "No Name")"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
