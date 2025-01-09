//
//  GameManager.swift
//  UpDownGame
//
//  Created by 박준우 on 1/9/25.
//

import Foundation

enum GameState {
    case settingGame
    case enterGame
    
    var subTitleString: String {
        switch self {
        case .settingGame:
            return "GAME"
        case .enterGame:
            return "시도 횟수: "
        }
    }
    
    var gameButtonString: String {
        switch self {
        case .settingGame:
            return "시작하기"
        case .enterGame:
            return "결과 확인하기"
        }
    }
}

class GameManager {
    var tryCount: Int = 0
    var randomNumber: Int?
    var maxNumber: Int?
    var selectedNumber: Int?
    var gameState: GameState = .settingGame
    var numberArray: [Int] = []
    var titleString: String {
        if let select = selectedNumber, let random = randomNumber {
            if select == random {
                return "Good!"
            } else if select > random {
                return "DOWN"
            } else if select < random {
                return "UP"
            } else {
                return "UP DOWN"
            }
        } else {
            return "UP DOWN"
        }
    }
    var isCorrect: Bool {
        if let select = selectedNumber, let random = randomNumber {
            return select == random
        } else {
            return false
        }
    }
    var isEnd: Bool = false
    
    func setSelectedNumber(_ numberString: String?) {
        if let number = Int(numberString ?? "") {
            selectedNumber = number
        } else {
            selectedNumber = nil
        }
    }
    
    func setMaxNumber(_ numberString: String) {
        if let number = Int(numberString) {
            maxNumber = number
        }
    }
    
    func reloadNumberArray() {
        tryCount += 1
        if let select = selectedNumber, let random = randomNumber {
            if select == random {
                print("정답")
            } else if select > random {
                numberArray = Array(numberArray.first!..<select)
                selectedNumber = nil
            } else if select < random {
                numberArray = Array((select + 1)...numberArray.last!)
                selectedNumber = nil
            }
        } else {
            print("selectedNumber or randomNumber is nil")
        }
    }
    
    func setRandomNumber() {
        if let max = maxNumber {
            numberArray = Array(1...max)
            randomNumber = numberArray.randomElement()!
        } else {
            print("maxNumber is nil")
        }
    }
    
    func resetGame() {
        tryCount = 0
        randomNumber = nil
        selectedNumber = nil
        maxNumber = nil
        gameState = .settingGame
        isEnd = false
    }
}
