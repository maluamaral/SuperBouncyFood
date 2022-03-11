//
//  GameMusic.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 06/03/22.
//

import AVFoundation

class Sound{
    
    private var soundPlay: AVAudioPlayer
    private var name: String
    private var formatSound: String
    var isMusic: Bool

    
    init(name: String, format: String, isMusic: Bool) {
        self.name = name
        self.formatSound = format
        self.isMusic = isMusic
        self.soundPlay = AVAudioPlayer()
        
    }
    
    init(){
        self.name = ""
        self.formatSound = ""
        self.isMusic = false
        self.soundPlay = AVAudioPlayer()
    }
    
    
    func playSound(){
        //if switchState{
            let path = Bundle.main.path(forResource: name, ofType: formatSound)!
            let url = URL(fileURLWithPath: path)
            
            do{
                soundPlay = try AVAudioPlayer(contentsOf: url)
                soundPlay.prepareToPlay()
                
                ListOfSound.shared.listOfSounds.append(self)
                
                if self.isMusic && ListOfSound.shared.switchMusicIsOn{
                    soundPlay.play()
                
                }
                if !self.isMusic && ListOfSound.shared.switchSoundEffectIsOn{
                    soundPlay.play()
                }
            }catch{
                print(error)
            }
 
    }
    
    
    func pauseSound(){
        if soundPlay.isPlaying {
            soundPlay.pause()
        }
        
    }
    
    func continueSound(){
        soundPlay.play()
        print("musica musica")
    }
    
    func stopSound(){
        soundPlay.stop()
    }
    
    func setVolume(volume: Float){
        soundPlay.volume = volume
    }
    
    func playSoundInLoop(){
            let path = Bundle.main.path(forResource: name, ofType: formatSound)!
            let url = URL(fileURLWithPath: path)
            
            do{
                soundPlay = try AVAudioPlayer(contentsOf: url)
                soundPlay.prepareToPlay()
                soundPlay.numberOfLoops = -1
                ListOfSound.shared.listOfSounds.append(self)
                
                if self.isMusic && ListOfSound.shared.switchMusicIsOn{
                    soundPlay.play()
                
                }
                if !isMusic && ListOfSound.shared.switchSoundEffectIsOn{
                    soundPlay.play()
                }
            }catch{
                print(error)
            }
        
    }
    
    
}
