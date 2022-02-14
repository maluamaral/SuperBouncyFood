//
//  GameOverViewController.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 11/02/22.
//

import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var continuePlayButton: UIButton!
    @IBOutlet weak var rankingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        continuePlayButton.setupButton(iconString: "film", color: UIColor.init(named: "creme")!)
        
        rankingButton.setupButton(iconString: "crown", color: UIColor.init(named: "creme")!)
        
        restartButton.setupButton(iconString: "arrow.clockwise", color: UIColor.init(named: "creme")!)
    }
    
}
