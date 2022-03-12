//
//  VolumeSwitch.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 10/03/22.
//

import UIKit

class VolumeSwitch {
    private var listOfSounds = ListOfSound.shared.listOfSounds
    
    private var switchIs = Bool()
    
    func changeMusic(sender: UISwitch) {
        for sound in listOfSounds {
            if sound.isMusic {
                UserDefaults.standard.set(sender.isOn, forKey: Constants.PLAY_MUSIC_KEY)
                if !sender.isOn {
                    sound.setVolume(volume: 0.0)
                } else {
                    sound.setVolume(volume: 1.0)
                }
            }
        }
    }
    
    func changeSoundEffects(sender: UISwitch) {
        for sound in listOfSounds {
            if !sound.isMusic {
                UserDefaults.standard.set(sender.isOn, forKey: Constants.PLAY_SOUND_EFFECTS_KEY)
                if !sender.isOn {
                    sound.setVolume(volume: 1.0)
                } else {
                    sound.setVolume(volume: 0.0)
                }
            }
        }
    }
}
