//
//  GameViewModel.swift
//  BubbleGame
//
//  Created by Dmitryi Velko on 17.10.2023.
//

import Foundation

enum BubbleType: Int {
    case blue = 1
    case red = 2
    case green = 3
}

enum ScreenSide {
    case top, bottom, left, right
}

final class GameViewModel {
        
    //MARK: Property
    var secondsRemaining: Double = 60.0
    var animationDuration: TimeInterval = 5.0

    //MARK: Method
    func reduceTime() {
        secondsRemaining -= 1.0
    }

    func isTimeOver() -> Bool {
        return secondsRemaining <= 0
    }
    
    func randomScreenSide() -> ScreenSide {
        let sides: [ScreenSide] = [.top, .bottom, .left, .right]
        return sides[Int.random(in: 0..<sides.count)]
    }
}
