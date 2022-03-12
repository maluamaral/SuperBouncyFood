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
        
        switchMusic.setOn(UserDefaults.standard.bool(forKey: Constants.PLAY_MUSIC_KEY), animated: false)
        switchSoundEffect.setOn(UserDefaults.standard.bool(forKey: Constants.PLAY_SOUND_EFFECTS_KEY), animated: false)
    }
    
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func changedSwitchMusic(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: Constants.PLAY_MUSIC_KEY)
        
        volumeSwitch.changeMusic(sender: sender)
        if sender.isOn {
            homeViewController?.playSound()
        }
    }
    
    @IBAction func changedSoundEffectSwitch(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: Constants.PLAY_SOUND_EFFECTS_KEY)
        
        volumeSwitch.changeSoundEffects(sender: sender)
    }
}
