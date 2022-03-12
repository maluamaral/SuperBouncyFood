//
//  PauseViewController.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 13/02/22.
//

import UIKit
import AVFoundation

class PauseViewController: UIViewController {
    var gameViewController: GameViewController?
    
    private var volumeSwitch = VolumeSwitch()
    
    @IBOutlet weak var soundEffectSwitch: UISwitch!
    @IBOutlet weak var musicSwitch: UISwitch!
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
        
        musicSwitch.setOn(ListOfSound.shared.switchMusicIsOn, animated: false)
        soundEffectSwitch.setOn(ListOfSound.shared.switchSoundEffectIsOn, animated: false)
    }
    
    
    @IBAction func goBackForStart(_ sender: UIButton) {
        gameViewController?.gameMusic.stopSound()
        gameViewController?.homeView?.playSound()
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
    @IBAction func changedMusicSwitch(_ sender: UISwitch){
        volumeSwitch.changeMusic(sender: sender)
        if sender.isOn {
            gameViewController?.playSound()
        }
    }
    @IBAction func changedSoundEffectSwitch(_ sender: UISwitch) {
        volumeSwitch.changeSoundEffects(sender: sender)
    }
}
