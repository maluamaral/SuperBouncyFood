//
//  GameOverViewController.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 11/02/22.
//

import UIKit
import GameKit
import GoogleMobileAds

class GameOverViewController: UIViewController, GKGameCenterControllerDelegate, GADFullScreenContentDelegate {
    var gameViewController: GameViewController?
    var currentScore: Int = 0
    var gcDefaultLeaderBoard: String = ""
    var rewardedAd: GADRewardedAd?
    var watchedRewardComplete = false
    
    var gameOverMusic = Sound(name: "gameOverMusic", format: ".mp3", isMusic: true)

    @IBOutlet private weak var gameOverLabel: UILabel!
    @IBOutlet private weak var restartButton: UIButton!
    @IBOutlet private weak var continuePlayButton: UIButton!
    @IBOutlet private weak var continuePlayLabel: UILabel!
    @IBOutlet private weak var rankingButton: UIButton!
    @IBOutlet private weak var recordLabel: UILabel!
    @IBOutlet private weak var currentScoreLabel: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.loadHighestScore()
        self.loadRewardedAd()
        
        gameOverMusic.playSoundInLoop()
        //gameOverMusic.setVolume(volume: 0.7)
    }
    
    private func setupView() {
        continuePlayButton.setupButton(iconString: "film", color: UIColor.init(named: "creme")!)
        rankingButton.setupButton(iconString: "crown", color: UIColor.init(named: "creme")!)
        restartButton.setupButton(iconString: "arrow.clockwise", color: UIColor.init(named: "creme")!)
        
        currentScoreLabel.text = String(format: "%05d", currentScore)
        recordLabel.text = String(format: "%05d", 0)
        
        self.setContinuePlayingButton(disbled: true)
    }
    
    // MARK: GADFullScreenContentDelegate
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Rewarded ad will be presented.")
        // TODO: Pausar musicas, sons e etc
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if (watchedRewardComplete) {
            gameViewController?.continueGame()
            self.dismiss(animated: true, completion: nil)
        } else {
            loadRewardedAd()
        }
    }
    
    private func loadRewardedAd() {
        guard let gameViewController = self.gameViewController else {
            print("gameViewController information needed")
            self.setContinuePlayingButton(disbled: true)
            return
        }
        
        if gameViewController.isTryingAgain {
            self.setContinuePlayingButton(disbled: true)
            return
        }
        
        GADRewardedAd.load(
            withAdUnitID: Environment.GAME_OVER_CONTINUE_REWARD_AD, request: GADRequest()
        ) { (ad, error) in
            if error != nil {
                self.setContinuePlayingButton(disbled: true)
                return
            }
            
            self.continuePlayButton.isEnabled = true
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
            self.setContinuePlayingButton(disbled: ad == nil)
        }
    }
    
    private func loadHighestScore() {
        self.recordLabel.text = String(format: "%05d", self.currentScore)
        GKLeaderboard.loadLeaderboards(IDs: [gcDefaultLeaderBoard]) { [weak self] (boards, error) in
            let board = boards?.first
            board?.loadEntries(for: .global, timeScope: .allTime, range: NSRange(location: 1, length: 10),
                                  completionHandler: { [weak self] (local, entries, count, error) in
                DispatchQueue.main.async {
                    let highestScore = (self?.currentScore ?? 0) > (local?.score ?? 0) ? self?.currentScore : local?.score
                    self?.recordLabel.text = String(format: "%05d", highestScore ?? 0)
                }
            })
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated:true)
    }
    
    func setContinuePlayingButton(disbled: Bool) {
        let alpha: CGFloat = disbled ? 0.5 : 1.0
        
        self.continuePlayButton.isEnabled = !disbled
        self.continuePlayButton.alpha = alpha
        self.continuePlayLabel.alpha = alpha
    }
    
    @IBAction func restartGame(_ sender: Any) {
        gameOverMusic.stopSound()
        gameViewController?.start()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToRanking(_ sender: Any) {
        let GameCenterVC = GKGameCenterViewController(leaderboardID: self.gcDefaultLeaderBoard, playerScope: .global, timeScope: .allTime)
        GameCenterVC.gameCenterDelegate = self
        present(GameCenterVC, animated: true, completion: nil)
    }
    
    @IBAction func seeAd(_ sender: Any) {
        gameOverMusic.stopSound()
        watchedRewardComplete = false
        guard let ad = rewardedAd else {
            return
        }
        
        ad.present(fromRootViewController: self) {
            self.watchedRewardComplete = true
        }
    }
}
