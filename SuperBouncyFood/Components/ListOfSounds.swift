//
//  ListOfSounds.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 10/03/22.
//

import Foundation
import AVFoundation

class ListOfSound{
    static let shared = ListOfSound()
    
    private init(){
        
    }
    
    var switchMusicIsOn: Bool = true
    var switchSoundEffectIsOn: Bool = true
    var listOfSounds = [Sound]()

}
