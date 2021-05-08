//
//  tableViewCell.swift
//  JsonImportExport
//
//  Created by sinpanda on 5/7/21.
//

import UIKit

class tableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateMain: UILabel!
    @IBOutlet weak var date1: UILabel!
    @IBOutlet weak var date2: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.cornerRadius = 10
        cellView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
