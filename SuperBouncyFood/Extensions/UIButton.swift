//
//  UIButton.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 11/02/22.
//

import UIKit


extension UIButton{
    
    func setupButton(iconString: String, color: UIColor) {
        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30, weight: .semibold))
        let image = UIImage(systemName: iconString, withConfiguration: configuration)?.withTintColor(color).withRenderingMode(.alwaysOriginal)
        
        self.setImage(image, for: .normal)
        self.tintColor = color
    }
    
    @IBInspectable var adjustFontSizeToWidth: Bool {
            get {
                return self.titleLabel?.adjustsFontSizeToFitWidth ?? false
            }
            set {
                self.titleLabel?.numberOfLines = 1
                self.titleLabel?.adjustsFontSizeToFitWidth = newValue;
                self.titleLabel?.lineBreakMode = .byClipping;
                self.titleLabel?.baselineAdjustment = .alignCenters
                self.titleLabel?.minimumScaleFactor = 0.5
            }
        }
    
}
