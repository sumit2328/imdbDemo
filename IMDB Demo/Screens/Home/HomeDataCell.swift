//
//  HomeDataCell.swift
//  IMDB Demo
//
//  Created by Sumit on 01/07/24.
//

import UIKit

class HomeDataCell: UICollectionViewCell {

    @IBOutlet weak var saveBtn: customButton!
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var titleTxt: UILabel!
    
    @IBOutlet weak var releaseYearTxt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
