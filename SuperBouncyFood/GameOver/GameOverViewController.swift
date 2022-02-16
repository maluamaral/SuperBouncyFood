//
//  GameOverViewController.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 11/02/22.
//

import UIKit
import GameKit

class GameOverViewController: UIViewController, GKGameCenterControllerDelegate {
    var gameViewController: GameViewController?
    var currentScore: Int = 0
    var gcDefaultLeaderBoard: String = ""
    
    @IBOutlet private weak var restartButton: UIButton!
    @IBOutlet private weak var continuePlayButton: UIButton!
    @IBOutlet private weak var rankingButton: UIButton!
    @IBOutlet private weak var recordLabel: UILabel!
    @IBOutlet private weak var currentScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.loadHighestScore()
    }
    
    private func setupView() {
        continuePlayButton.setupButton(iconString: "film", color: UIColor.init(named: "creme")!)
        rankingButton.setupButton(iconString: "crown", color: UIColor.init(named: "creme")!)
        restartButton.setupButton(iconString: "arrow.clockwise", color: UIColor.init(named: "creme")!)
        
        currentScoreLabel.text = String(format: "%05d", currentScore)
        recordLabel.text = String(format: "%05d", 0)
    }
    
    private func loadHighestScore() {
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
    
    @IBAction func restartGame(_ sender: Any) {
        gameViewController?.start()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToRanking(_ sender: Any) {
        let GameCenterVC = GKGameCenterViewController(leaderboardID: self.gcDefaultLeaderBoard, playerScope: .global, timeScope: .allTime)
        GameCenterVC.gameCenterDelegate = self
        present(GameCenterVC, animated: true, completion: nil)
    }
    
    @IBAction func seeAd(_ sender: Any) {
        print("see ad")
    }
}
