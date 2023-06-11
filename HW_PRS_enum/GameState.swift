//
//  GameState.swift
//  HW_PRS_enum
//
//  Created by 曹家瑋 on 2023/6/10.
//

import Foundation

/*
 遊戲可以有四種不同的狀態：
 
 開始（Start）：遊戲顯示三個手勢，等待用戶點擊其中一個。
 贏（Win）：玩家獲勝，應用程式顯示每個動作和贏的訊息。
 輸（Lose）：玩家失敗，應用程式顯示每個動作和輸的訊息。
 平手（Draw）：遊戲平局，應用程式顯示每個動作和平局的訊息。
 */

import Foundation

// 規則建立
enum GameState {
    case start
    case win
    case lose
    case draw
    
    var gameState: String {
        switch self {
        case .start:                          // 比賽開始
            return "Time to fight!"
        case .win:                            // 攻擊成功
            return "You Win!"
        case .lose:                           // 攻擊失敗
            return "You Lose!"
        case .draw:                           // 攻擊和局
            return "It's a Draw!"
        }
    }
}
