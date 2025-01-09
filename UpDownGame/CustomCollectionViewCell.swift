//
//  CustomCollectionViewCell.swift
//  UpDownGame
//
//  Created by 박준우 on 1/9/25.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    static let id: String = "CustomCollectionViewCell"
    
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numberLabel.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func configureUnSelectedCell() {
        self.backgroundColor = UIColor.white
        self.numberLabel.textColor = UIColor.black
    }
    
    func configureSelectedCell() {
        self.backgroundColor = UIColor.black
        self.numberLabel.textColor = UIColor.white
    }
}
