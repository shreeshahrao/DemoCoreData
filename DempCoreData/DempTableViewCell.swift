//
//  DempTableViewCell.swift
//  DempCoreData
//
//  Created by Shreesha on 23/11/21.
//

import UIKit
import CoreData

class DempTableViewCell: UITableViewCell {

    
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
