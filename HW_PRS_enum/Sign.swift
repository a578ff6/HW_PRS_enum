//
//  Sign.swift
//  HW_PRS_enum
//
//  Created by 曹家瑋 on 2023/6/10.
//

import Foundation
import UIKit

// 圖示 （盾牌、劍和弓箭）
enum Sign {
    
    case shield
    case sword
    case bow
    
    // weaponImage 計算屬性，根據武器的不同，返回相應的武器圖片。
    var weaponImage: UIImage? {
        switch self {
        case .shield:
            return UIImage(named: "shield")
        case .sword:
            return UIImage(named: "sword")
        case .bow:
            return UIImage(named: "bow")
        }
    }
    
    // 比較兩個 Sign 實例並返回對應的 GameState
    func compare(with opponent: Sign) -> GameState {
        switch self {
            // 玩家為盾牌的時候
        case .shield:
            switch opponent {
            case .shield:
                return .draw
            case .sword:
                return .win
            case .bow:
                return .lose
        }
            // 玩家為劍的時候
        case .sword:
            switch opponent {
            case .shield:
                return .lose
            case .sword:
                return .draw
            case .bow:
                return .win
            }
            // 玩家為弓的時候
        case .bow:
            switch opponent {
            case .shield:
                return .win
            case .sword:
                return .lose
            case .bow:
                return .draw
            }
        }
    }
    
}

// 使用Sign列舉來創立武器隨機種類（給電腦用）
func randomWeaponSign() -> Sign {
    // 因為只有三件武器，因此為 0...2
    let weaponSignIndex = Int.random(in: 0...2)

    if weaponSignIndex == 0 {
        return .shield
    } else if weaponSignIndex == 1 {
        return .sword
    } else {
        return .bow
    }
}



/*
 首先檢查兩個手勢是否相同，如果相同則返回 .draw。否則，我們檢查各種可能的贏的情況：當自己是盾牌（shield）並且對手是劍（sword），或者自己是劍並且對手是弓箭（bow），或者自己是弓箭並且對手是盾牌時，返回 .win。如果上述兩種情況都不滿足，則返回 .lose。
 */

// 另一種寫法 （要在enum裡使用)
//    func compare(with opponent: Sign) -> GameState {
//        if self == opponent {
//            return .draw
//        } else if (self == .shield && opponent == .sword) || (self == .sword && opponent == .bow) || (self == .bow && opponent == .shield) {
//            return .win
//        } else {
//            return .lose
//        }
//    }


// 武器隨機種類（給電腦用）(另一種寫法）
//func randomWeaponSign() -> Sign {
//    let weaponSign = Int.random(in: 0...2)
//
//    switch weaponSign {
//    case 0:
//        return .shield
//    case 1:
//        return .sword
//    default:
//        return .bow
//    }
//}
