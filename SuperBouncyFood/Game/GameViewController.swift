//
//  GameViewController.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 27/01/22.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    var gcDefaultLeaderBoard: String = ""
    var isDisplayingGameOver = false
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var measureLabel: UILabel!
    @IBOutlet private weak var pauseButton: UIButton!
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.start()
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated:true)
    }
    
    private func setupView() {
        self.pauseButton.setupButton(iconString: "pause.fill", color: UIColor.init(named: "preto")!)
        // Score
        self.scoreLabel.textColor = UIColor(named: "preto")!
        self.scoreLabel.tintColor = UIColor(named: "preto")!
        // Measure
        self.measureLabel.textColor = UIColor(named: "preto")!
        self.measureLabel.tintColor = UIColor(named: "preto")!
    }
    
    func start() {
        self.scoreLabel.text = String(format: "%05d", 0)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.viewController = self
               
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    @IBAction func leaderBoardClicked(_ sender: Any) {
        let GameCenterVC = GKGameCenterViewController(leaderboardID: self.gcDefaultLeaderBoard, playerScope: .global, timeScope: .allTime)
        GameCenterVC.gameCenterDelegate = self
        present(GameCenterVC, animated: true, completion: nil)
    }
    
    @IBAction func pauseGame(_ sender: Any) {
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "pause") as! PauseViewController
        newViewController.modalPresentationStyle = .custom
        newViewController.gameViewController = self
        
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func updateScore(_ score: Int) {
        self.scoreLabel.text = String(format: "%05d", score)
    }
    
    func gameOver(score: Int) {
        if isDisplayingGameOver {
            return
        }
        
        // Update score
        if (GKLocalPlayer.local.isAuthenticated) {
            GKLeaderboard.submitScore(
                score,
                context: 0,
                player: GKLocalPlayer.local,
                leaderboardIDs: [self.gcDefaultLeaderBoard]
            ) { error in
                if let error = error {
                    print(error)
                }
            }
        }
        
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "gameOver") as! GameOverViewController
        newViewController.modalPresentationStyle = .custom
        newViewController.gameViewController = self
        newViewController.currentScore = score
        newViewController.gcDefaultLeaderBoard = gcDefaultLeaderBoard
        
        isDisplayingGameOver = true
        self.present(newViewController, animated: true, completion: nil)
    }
}

