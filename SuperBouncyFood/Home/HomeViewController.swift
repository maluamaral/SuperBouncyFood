//
//  HomeViewController.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 10/02/22.
//

import UIKit

class HomeViewController: UIViewController {


    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var rankingButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.setupButton(iconString: "play", color: UIColor.init(named: "brigadeiro")!)
        
        rankingButton.setupButton(iconString: "crown", color: UIColor.init(named: "brigadeiro")!)
        
        settingsButton.setupButton(iconString: "gearshape", color: UIColor.init(named: "brigadeiro")!)
        
        
        
        

        // Do any additional setup after loading the view.
    }

    
    @IBAction func sentoToGameOver(_ sender: UIButton) {
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "gameOver") as! GameOverViewController
        newViewController.modalPresentationStyle = .custom
        self.present(newViewController, animated: true, completion: nil)
    
    }
    
    @IBAction func sentToSettings(_ sender: UIButton) {
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        newViewController.modalPresentationStyle = .custom
        self.present(newViewController, animated: true, completion: nil)
    
    }
    
    @IBAction func sendToPause(_ sender: UIButton) {
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "pause") as! PauseViewController
        newViewController.modalPresentationStyle = .custom
        self.present(newViewController, animated: true, completion: nil)
    }
}
