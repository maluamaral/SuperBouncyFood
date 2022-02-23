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
import GoogleMobileAds

class GameViewController: UIViewController, GKGameCenterControllerDelegate, GADFullScreenContentDelegate {
    var gcDefaultLeaderBoard: String = ""
    var isDisplayingGameOver = false
    var isTryingAgain = false
    var firstPlatformPosition: SKNode?
    
    @IBOutlet weak var bannerView: GADBannerView!
    private var interstitial: GADInterstitialAd?
    
    private var currentScore: Int = 0
    
    private var gameScene: GameScene?
    
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
        
        loadBannerAd()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestBannerAd()
        requestInterstitial()
    }
    
    override func viewWillTransition(
        to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
    ) {
        coordinator.animate(alongsideTransition: { _ in
            self.requestBannerAd()
        })
    }
    
    func loadBannerAd() {
        bannerView.adUnitID = Environment.BANNER_AD_HOME
        bannerView.rootViewController = self
    }
    
    func requestBannerAd() {
        let frame = { () -> CGRect in
            if #available(iOS 11.0, *) {
                return view.frame.inset(by: view.safeAreaInsets)
            } else {
                return view.frame
            }
        }()
        let viewWidth = frame.size.width
        
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView.load(GADRequest())
        bannerView.backgroundColor = .black
    }
    
    func requestInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(
            withAdUnitID: Environment.INTERSTITIAL_AD_GAME_OVER,
            request: request,
            completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
            }
        )
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
        self.continueGameOver()
    }
    
    /// Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
        // TODO: Pausar musicas, sons e etc
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        self.requestInterstitial()
        self.continueGameOver()
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
        self.isTryingAgain = false
        self.isDisplayingGameOver = false
        self.scoreLabel.text = String(format: "%05d", 0)
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.viewController = self
                self.gameScene = scene
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = Environment.SHOW_FPS_AND_NODES
            view.showsNodeCount = Environment.SHOW_FPS_AND_NODES
        }
    }
    
    func continueGame() {
        guard let firstPlatformPosition = self.firstPlatformPosition else {
            return
        }
        
        isDisplayingGameOver = false
        isTryingAgain = true
        gameScene?.updatePlayerPosition(position: CGPoint(x: firstPlatformPosition.position.x + 5.0, y: firstPlatformPosition.frame.maxY + 5.0))
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
        
        self.currentScore = score
        isDisplayingGameOver = true
        
        showInterstitialAd()
    }
    
    func continueGameOver() {
        // Update score
        if (GKLocalPlayer.local.isAuthenticated) {
            GKLeaderboard.submitScore(
                self.currentScore,
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
        newViewController.currentScore = self.currentScore
        newViewController.gcDefaultLeaderBoard = gcDefaultLeaderBoard
        
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func showInterstitialAd() {
        guard let interstitial = interstitial else {
            print("Ad wasn't ready")
            continueGameOver()
            return
        }
        
        interstitial.present(fromRootViewController: self)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20.0)
        ]
        view.addSubview(bannerView)
        view.addConstraints(constraints)
    }
}

