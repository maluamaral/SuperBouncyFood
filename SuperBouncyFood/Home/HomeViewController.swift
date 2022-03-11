//
//  HomeViewController.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 10/02/22.
//

import UIKit
import GameKit
import AVFoundation
import AppTrackingTransparency
import AdSupport

class HomeViewController: UIViewController, GKGameCenterControllerDelegate {
    @IBOutlet private weak var settingsButton: UIButton!
    @IBOutlet private weak var rankingButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    var homeMusic = Sound(name: "homeMusic", format: ".mp3", isMusic: true)
    
    var gcDefaultLeaderBoard = "General" // Check the default leaderboardID
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authenticateLocalPlayer()
        self.setupView()
        
        playSound()
        
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            print("status - \(status)")
        })
    }
    
    private func setupView() {
        self.view.backgroundColor = .red
        playButton.setupButton(iconString: "play", color: UIColor.init(named: "brigadeiro")!)
        rankingButton.setupButton(iconString: "crown", color: UIColor.init(named: "brigadeiro")!)
        settingsButton.setupButton(iconString: "gearshape", color: UIColor.init(named: "brigadeiro")!)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated:true)
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local

        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if ((ViewController) != nil) {
                // Show game center login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        print(error!)
                    }
                    else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                 })
            } else {
                // Game center is not enabled on the user's device
                print("Local player could not be authenticated!")
                print(error!)
            }
        }
    }

    
    @IBAction func sentoToGame(_ sender: UIButton) {
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "game") as! GameViewController
        newViewController.modalPresentationStyle = .custom
        newViewController.gcDefaultLeaderBoard = gcDefaultLeaderBoard
        newViewController.homeView = self
        self.homeMusic.stopSound()
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func sentToSettings(_ sender: UIButton) {
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        newViewController.modalPresentationStyle = .custom
        self.present(newViewController, animated: true, completion: nil)
        
    
    }
    
    @IBAction func sendToRanking(_ sender: UIButton) {
        let GameCenterVC = GKGameCenterViewController(leaderboardID: self.gcDefaultLeaderBoard, playerScope: .global, timeScope: .allTime)
        GameCenterVC.gameCenterDelegate = self
        present(GameCenterVC, animated: true, completion: nil)
    }
    
    func playSound(){
        if ListOfSound.shared.switchMusicIsOn{
            homeMusic.playSoundInLoop()
        }
        
    }
}
