//
//  PauseViewController.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 13/02/22.
//

import UIKit

class PauseViewController: UIViewController {
    var gameViewController: GameViewController?
    
    @IBOutlet private weak var homeButton: UIButton!
    @IBOutlet private weak var restartButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeButton.titleLabel?.numberOfLines = 1
        homeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        homeButton.titleLabel!.baselineAdjustment = .alignCenters
        homeButton.titleLabel?.lineBreakMode = .byClipping


        playButton.setupButton(iconString: "play", color: UIColor.init(named: "creme")!)
        restartButton.setupButton(iconString: "arrow.clockwise", color: UIColor.init(named: "creme")!)
    }
    

    @IBAction func goBackForStart(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBackToGame(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func returnToGame(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restartGame(_ sender: Any) {
        gameViewController?.start()
        self.dismiss(animated: true, completion: nil)
    }
}
