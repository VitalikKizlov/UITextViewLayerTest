//
//  ColorCollectionViewCell.swift
//  Plugin
//
//  Created by Vitalii Kizlov on 04.03.2020.
//  Copyright © 2020 Max Lynch. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    static var nib: UINib {
        return UINib(nibName: String(describing: ColorCollectionViewCell.self), bundle: nil)
    }
    
    static var reuseIdentifier: String {
        return String(describing: ColorCollectionViewCell.self)
    }
    
    @IBOutlet weak var colorView: UIView!
    
    override var bounds: CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colorView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        colorView.layer.cornerRadius = colorView.frame.width / 2
        colorView.layer.borderColor = UIColor.white.withAlphaComponent(0.22).cgColor
        colorView.layer.borderWidth = 2
    }

}
