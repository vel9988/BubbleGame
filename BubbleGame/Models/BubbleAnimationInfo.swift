//
//  BubbleAnimationInfo.swift
//  BubbleGame
//
//  Created by Dmitryi Velko on 17.10.2023.
//

import Foundation
import UIKit

struct BubbleAnimationInfo {
    var startPoint: CGPoint
    var endPoint: CGPoint
    weak var bubble: UIImageView?
    var displayLink: CADisplayLink
    var startTime: CFTimeInterval
}
