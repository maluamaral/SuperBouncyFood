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
                if !sender.isOn {
                    sound.setVolume(volume: 0.0)
                    ListOfSound.shared.switchMusicIsOn = false
                } else {
                    sound.setVolume(volume: 1.0)
                    ListOfSound.shared.switchMusicIsOn = true
                }
            }
        }
    }
    
    func changeSoundEffects(sender: UISwitch){
        for sound in listOfSounds {
            if !sound.isMusic{
                if !sender.isOn {
                    sound.setVolume(volume: 1.0)
                    ListOfSound.shared.switchSoundEffectIsOn = false
                }else{
                    sound.setVolume(volume: 0.0)
                    ListOfSound.shared.switchSoundEffectIsOn = true
                }
            }
        }
    }
}
