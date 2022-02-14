//
//  UIButton.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 11/02/22.
//

import UIKit


extension UIButton{
    
    func setupButton(iconString: String, color: UIColor){
        let configuration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 30, weight: .semibold))
        
        self.setImage(UIImage(systemName: iconString, withConfiguration: configuration), for: .normal)
        self.tintColor = color
    }
    
}
