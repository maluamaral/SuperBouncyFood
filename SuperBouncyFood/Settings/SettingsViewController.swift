//
//  SettingsViewController.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 13/02/22.
//

import UIKit
import AVFoundation
import MediaPlayer

class SettingsViewController: UIViewController {

    var homeViewController: HomeViewController?
    
    private var volumeSwitch = VolumeSwitch()
    @IBOutlet weak var switchMusic: UISwitch!
    
    @IBOutlet weak var switchSoundEffect: UISwitch!
    private var sounds = HomeViewController()
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchMusic.setOn(ListOfSound.shared.switchMusicIsOn, animated: false)
        switchSoundEffect.setOn(ListOfSound.shared.switchSoundEffectIsOn, animated: false)
    }
    
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func changedSwitchMusic(_ sender: UISwitch) {
        volumeSwitch.changeMusic(sender: sender)
        if sender.isOn {
            homeViewController?.playSound()
        }
    }
    
    @IBAction func changedSoundEffectSwitch(_ sender: UISwitch) {
        volumeSwitch.changeSoundEffects(sender: sender)
    }
}
