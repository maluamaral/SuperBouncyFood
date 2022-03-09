//
//  SettingsViewController.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 13/02/22.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet private weak var closeButton: UIButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.removeLabel()
    }
    
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    
    }


}
