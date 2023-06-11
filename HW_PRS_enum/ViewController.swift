//
//  ViewController.swift
//  HW_PRS_enum
//
//  Created by 曹家瑋 on 2023/6/10.
//



import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // 起始遊戲畫面、起始遊戲按鈕
    @IBOutlet weak var startGameView: UIView!
    @IBOutlet weak var startGameButton: UIButton!
    
    // 三個武器的outlet
    @IBOutlet weak var playerShieldButton: UIButton!
    @IBOutlet weak var playerSwordButton: UIButton!
    @IBOutlet weak var playerBowButton: UIButton!
    
    // 重玩的outlet
    @IBOutlet weak var playAgainButton: UIButton!
    
    // 比賽狀態結果
    @IBOutlet weak var gameStateLabel: UILabel!
    
    // 玩家以及電腦的武器
    @IBOutlet weak var playerWeaponImageView: UIImageView!
    @IBOutlet weak var computerWeaponImageView: UIImageView!
    
    // 遊戲結束畫面（遊戲結束才會出現）
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var victoryView: UIView!
    
    // 雙方血量
    @IBOutlet weak var playerHealthlabel: UILabel!
    @IBOutlet weak var computerHealthLabel: UILabel!
    
    // 雙方的HP血量
    var playerHpCount = 10
    var computerHpCount = 10
    
    // 音效播放
    let soundPlayer = AVPlayer()
    
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 隱藏遊戲結束的畫面資訊（重玩按鈕）
        gameOverView.isHidden = true
        victoryView.isHidden = true
        // 預設遊戲狀態文字（ GameState.start.gameState）
        gameStateLabel.text = "Time to fight!"
 
    }
    
    
    // 盾牌
    @IBAction func showShieldButtonTapped(_ sender: UIButton) {
        
        // 玩家的武器（對應Button）
        let playerWeapon: Sign = .shield
        // 電腦的武器
        let computerWeapon: Sign = randomWeaponSign()
        // 雙方比較結果
        let battle = playerWeapon.compare(with: computerWeapon)
        // 將結果反映到Label上
        gameStateLabel.text = battle.gameState
        // 透過遊戲結果來更新背景色、音效、當前狀態反應的血量
        updateUI(gameState: battle)
        // 顯示武器圖片
        playerWeaponImageView.image = playerWeapon.weaponImage
        computerWeaponImageView.image = computerWeapon.weaponImage
        
        // 遊戲最終結果
        checkGameOver()
    }
    
    // 劍
    @IBAction func showSwordButtonTapped(_ sender: UIButton) {
        
        let playerWeapon: Sign = .sword
        let computerWeapon: Sign = randomWeaponSign()
        
        let battle = playerWeapon.compare(with: computerWeapon)
        gameStateLabel.text = battle.gameState
        updateUI(gameState: battle)
        
        playerWeaponImageView.image = playerWeapon.weaponImage
        computerWeaponImageView.image = computerWeapon.weaponImage
        
        // 遊戲最終結果
        checkGameOver()
    }
    
    // 弓
    @IBAction func showBowButtonTapped(_ sender: UIButton) {
        
        let playerWeapon: Sign = .bow
        let computerWeapon: Sign = randomWeaponSign()
        
        let battle = playerWeapon.compare(with: computerWeapon)
        gameStateLabel.text = battle.gameState
        updateUI(gameState: battle)
        
        playerWeaponImageView.image = playerWeapon.weaponImage
        computerWeaponImageView.image = computerWeapon.weaponImage
        
        // 遊戲最終結果
        checkGameOver()
    }
    
    // 重玩（遊戲結束才會出現）
    @IBAction func playAgainButtonTapped(_ sender: UIButton) {
        // 為暫停遊戲結束產生的勝利或是死亡音效
        soundPlayer.pause()
        // 播放 playAgainButtonTapped 的音效
        updateUI(gameState: .start)
        // 將狀態文字設置回 .start
        gameStateLabel.text = GameState.start.gameState
        // 隱藏 遊戲結束 的畫面資訊（重玩按鈕）
        gameOverView.isHidden = true
        victoryView.isHidden = true
        // 啟用武器按鈕
        playerShieldButton.isEnabled = true
        playerSwordButton.isEnabled = true
        playerBowButton.isEnabled = true
        // 重新計算Hp
        playerHpCount = 10
        computerHpCount = 10
        playerHealthlabel.text = "10/\(playerHpCount)"
        computerHealthLabel.text = "10/\(computerHpCount)"
        // 清楚場上的武器
        playerWeaponImageView.image = nil
        computerWeaponImageView.image = nil
    }
    
    // 開始遊戲按鈕
    @IBAction func stratGameButtonTapped(_ sender: UIButton) {
        // 設置遊戲狀態
        updateUI(gameState: .start)
        // 隱藏遊戲開始畫面、遊戲開始按鈕
        startGameView.isHidden = true
        startGameButton.isHidden = true
    }
    
    // 不同的遊戲狀態改變背景顏色、播放遊戲狀態相對應的音效、更新血量
    func updateUI(gameState: GameState) {
        // 設定背景顏色
        switch gameState {
        case .start:
            view.backgroundColor = .systemGreen
        case .win:
            view.backgroundColor = .orange
        case .lose:
            view.backgroundColor = .lightGray
        case .draw:
            view.backgroundColor = UIColor(red: 0, green: 255, blue: 255, alpha: 1)
        }
        
        // 播放音效
        playSound(for: gameState)
        // 更新血量
        updateHealth(with: gameState)
    }
    
    // 音效播放（會給updateUI使用）
    func playSound(for gameState: GameState) {
        // 使用 switch 根據 gameState 的值來選擇適當的音效文件的 URL。
        var soundUrl: URL?
        
        switch gameState {
        case .start:
            soundUrl = Bundle.main.url(forResource: "StartSound", withExtension: "mp3")
        case .win:
            soundUrl = Bundle.main.url(forResource: "WinSound", withExtension: "mp3")
        case .lose:
            soundUrl = Bundle.main.url(forResource: "LoseSound", withExtension: "mp3")
        case .draw:
            soundUrl = Bundle.main.url(forResource: "DrawSound", withExtension: "mp3")
        }
        
        // 通過 guard let 來確保 soundUrl 不為空，如果為空則直接返回。
        guard let url = soundUrl else {
            return
        }
        
        // 使用 url 作為參數。這個 AVPlayerItem 對象表示要播放的音效文件。
        let playerItem = AVPlayerItem(url: url)
        soundPlayer.replaceCurrentItem(with: playerItem)
        soundPlayer.rate = 0.5
        soundPlayer.play()
    }
    
    // 血量更新（會給updateUI使用）
    func updateHealth(with gameState: GameState) {
        // 如果玩家的狀態贏
        if gameState == .win {
            computerHpCount -= 1
            computerHealthLabel.text = "10/\(computerHpCount)"
        }
        // 如果玩家的狀態輸
        else if gameState == .lose {
            playerHpCount -= 1
            playerHealthlabel.text = "10/\(playerHpCount)"
        }
    }
    
    // 遊戲最終結果（單獨判斷）
    func checkGameOver() {
        // 玩家血量歸0
        if playerHpCount == 0 {
            // 禁用所有按鈕
            playerShieldButton.isEnabled = false
            playerSwordButton.isEnabled = false
            playerBowButton.isEnabled = false
            // 顯示 GameOverView 的畫面資訊（重玩按鈕）
            gameOverView.isHidden = false
            // 玩家輸，電腦贏
            dieSound()
        }
        // 電腦血量歸0
        else if computerHpCount == 0 {
            // 禁用所有按鈕
            playerShieldButton.isEnabled = false
            playerSwordButton.isEnabled = false
            playerBowButton.isEnabled = false
            // 顯示 Victory 的畫面資訊（重玩按鈕）
            victoryView.isHidden = false
            // 玩家贏，電腦輸
            victorySound()
        }
    }
    
    // 勝利音效（給checkGameOver使用）
    func victorySound() {
        let soundUrl = Bundle.main.url(forResource: "VictorySound", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: soundUrl)
        soundPlayer.replaceCurrentItem(with: playerItem)
        soundPlayer.rate = 0.5
        soundPlayer.play()
    }
    // 死亡音效（給checkGameOver使用）
    func dieSound() {
        let soundUrl = Bundle.main.url(forResource: "GameOverSound", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: soundUrl)
        soundPlayer.replaceCurrentItem(with: playerItem)
        soundPlayer.rate = 0.5
        soundPlayer.play()
    }

}


//    // 血量更新（會給updateUI使用）
//    func updateHealth(with gameState: GameState) {
//        switch gameState {
//        case .win:
//            computerHpCount -= 1
//            computerHealthLabel.text = "10/\(computerHpCount)"
//        case .lose:
//            playerHpCount -= 1
//            playerHealthlabel.text = "10/\(playerHpCount)"
//        case .draw:
//            break
//        default:
//            break
//        }
//    }


// 先前版本
//import UIKit
//import AVFoundation
//
//class ViewController: UIViewController {
//
//    // 三個武器的outlet
//    @IBOutlet weak var playerShieldButton: UIButton!
//    @IBOutlet weak var playerSwordButton: UIButton!
//    @IBOutlet weak var playerBowButton: UIButton!
//
//    // 重玩的outlet
//    @IBOutlet weak var playAgainButton: UIButton!
//
//    // 比賽狀態結果
//    @IBOutlet weak var gameStateLabel: UILabel!
//
//    // 雙方血量
//    @IBOutlet weak var computerHealthLabel: UILabel!
//    @IBOutlet weak var playerHealthlabel: UILabel!
//
//    // 玩家以及電腦的武器
//    @IBOutlet weak var playerWeaponImageView: UIImageView!
//    @IBOutlet weak var computerWeaponImageView: UIImageView!
//
//    // 雙方的HP血量
//    var playerHpCount = 10
//    var computerHpCount = 10
//
//    // 音效播放
//    let soundPlayer = AVPlayer()
//
//    // viewDidLoad
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //隱藏重玩按鈕
//        playAgainButton.isHidden = true
//        // 預設遊戲狀態文字
//        gameStateLabel.text = GameState.start.gameState
//
//    }
//
//
//    // 盾牌
//    @IBAction func showShieldButtonTapped(_ sender: UIButton) {
//
//        // 玩家的武器（對應Button）
//        let playerWeapon: Sign = .shield
//        // 電腦的武器
//        let computerWeapon: Sign = randomWeaponSign()
//        // 比較雙方結果
//        let battle = playerWeapon.compare(with: computerWeapon)
//        gameStateLabel.text = battle.gameState
//        updateUI(gameState: battle)
//        // 顯示武器圖片
//        playerWeaponImageView.image = playerWeapon.weaponImage
//        computerWeaponImageView.image = computerWeapon.weaponImage
//        // HP血量更新
//        updateHealth(with: battle)
//        checkGameOver()
//    }
//
//    // 劍
//    @IBAction func showSwordButtonTapped(_ sender: UIButton) {
//
//        let playerWeapon: Sign = .sword
//        let computerWeapon: Sign = randomWeaponSign()
//
//        let battle = playerWeapon.compare(with: computerWeapon)
//        gameStateLabel.text = battle.gameState
//        updateUI(gameState: battle)
//
//        playerWeaponImageView.image = playerWeapon.weaponImage
//        computerWeaponImageView.image = computerWeapon.weaponImage
//
//        updateHealth(with: battle)
//        checkGameOver()
//    }
//
//    // 弓
//    @IBAction func showBowButtonTapped(_ sender: UIButton) {
//
//        let playerWeapon: Sign = .bow
//        let computerWeapon: Sign = randomWeaponSign()
//
//        let battle = playerWeapon.compare(with: computerWeapon)
//        gameStateLabel.text = battle.gameState
//        updateUI(gameState: battle)
//
//        playerWeaponImageView.image = playerWeapon.weaponImage
//        computerWeaponImageView.image = computerWeapon.weaponImage
//
//        updateHealth(with: battle)
//        checkGameOver()
//    }
//
//    // 重玩（遊戲結束才會出現）
//    @IBAction func playAgainButtonTapped(_ sender: UIButton) {
//        updateUI(gameState: .start)
//    }
//
//    // 不同的遊戲狀態改變背景顏色
//    func updateUI(gameState: GameState) {
//        // 設定背景顏色
//        switch gameState {
//        case .start:
//            view.backgroundColor = .systemGreen
//        case .win:
//            view.backgroundColor = .orange
//        case .lose:
//            view.backgroundColor = .lightGray
//        case .draw:
//            view.backgroundColor = UIColor(red: 0, green: 255, blue: 255, alpha: 1)
//        }
//
//        // 音效設置
//        switch gameState {
//        case .start:
//            playerStartSound()
//        case .win:
//            playerWinSound()
//        case .lose:
//            playerLoseSound()
//        case .draw:
//            playerDrawSound()
//        }
//    }
//
//    // Start音效
//    func playerStartSound() {
//        let soundUrl = Bundle.main.url(forResource: "StartSound", withExtension: "mp3")!
//        let playerItem = AVPlayerItem(url: soundUrl)
//        soundPlayer.replaceCurrentItem(with: playerItem)
//        soundPlayer.rate = 0.5
//        soundPlayer.play()
//    }
//
//    // Win音效
//    func playerWinSound() {
//        let soundUrl = Bundle.main.url(forResource: "WinSound", withExtension: "mp3")!
//        let playerItem = AVPlayerItem(url: soundUrl)
//        soundPlayer.replaceCurrentItem(with: playerItem)
//        soundPlayer.rate = 0.5
//        soundPlayer.play()
//    }
//
//    // Lose音效
//    func playerLoseSound() {
//        let soundUrl = Bundle.main.url(forResource: "LoseSound", withExtension: "mp3")!
//        let playerItem = AVPlayerItem(url: soundUrl)
//        soundPlayer.replaceCurrentItem(with: playerItem)
//        soundPlayer.rate = 0.5
//        soundPlayer.play()
//    }
//
//    // Draw音效
//    func playerDrawSound() {
//        let soundUrl = Bundle.main.url(forResource: "DrawSound", withExtension: "mp3")!
//        let playerItem = AVPlayerItem(url: soundUrl)
//        soundPlayer.replaceCurrentItem(with: playerItem)
//        soundPlayer.rate = 0.5
//        soundPlayer.play()
//    }
//
//    // 血量更新
//    func updateHealth(with gameState: GameState) {
//        switch gameState {
//        case .win:
//            computerHpCount -= 1
//            computerHealthLabel.text = "10/\(computerHpCount)"
//        case .lose:
//            playerHpCount -= 1
//            playerHealthlabel.text = "10/\(playerHpCount)"
//        case .draw:
//            break
//        default:
//            break
//        }
//    }
//
//    // 遊戲最終結果
//    func checkGameOver() {
//        // 玩家血量歸0
//        if playerHpCount == 0 {
//            playerShieldButton.isEnabled = false
//            playerSwordButton.isEnabled = false
//            playerBowButton.isEnabled = false
//        }
//        // 電腦血量歸0
//        else if computerHpCount == 0 {
//            playerShieldButton.isEnabled = false
//            playerSwordButton.isEnabled = false
//            playerBowButton.isEnabled = false
//        }
//    }
//
//}

