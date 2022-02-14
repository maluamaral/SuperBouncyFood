//
//  PauseViewController.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 13/02/22.
//

import UIKit

class PauseViewController: UIViewController {
    

    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playButton.setupButton(iconString: "play", color: UIColor.init(named: "creme")!)
        
        restartButton.setupButton(iconString: "arrow.clockwise", color: UIColor.init(named: "creme")!)
        
    }
    

    @IBAction func goBackForStart(_ sender: UIButton) {
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "start") as! HomeViewController
        newViewController.modalPresentationStyle = .custom
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func goBackToGame(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
