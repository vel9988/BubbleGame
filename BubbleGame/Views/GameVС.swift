//
//  GameVС.swift
//  BubbleGame
//
//  Created by Dmitryi Velko on 17.10.2023.
//

import UIKit

class GameVC: UIViewController {
    
    //MARK: Property
    
    private var animations: [BubbleAnimationInfo] = []
    
    private var animationDuration: TimeInterval = 5.0
    private var animationStartTime: CFTimeInterval?
    private var bubbleStartPoint: CGPoint?
    private var bubbleEndPoint: CGPoint?
    private var currentAnimatingBubble: UIImageView?
    
    private var stripWidth: CGFloat = 0
    
    var secondsRemaining = 60.0
    let timerInterval = 1.0
    
    var elapsedSeconds = 0

    var timer: Timer?
    
    let viewModel = GameViewModel()
    
    //MARK: Subviews
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "GamePlay")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let timeLineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TimeLine")
        return imageView
    }()
    
    private let timeLineBGImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "TimeLineBG")
        return imageView
    }()
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Time")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let mainBubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MainBubble")
        return imageView
    }()

    //MARK: LiveCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavBar()
        getConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    //MARK: Setup
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(timeLineBGImageView)
        view.addSubview(timeLineImageView)
        view.addSubview(timeImageView)
        view.addSubview(mainBubbleImageView)
        
        stripWidth = self.view.frame.width - 40
        

    }
    
    private func setupNavBar() {
        navigationItem.hidesBackButton = true
//        let homeButton = UIImage(named: "HomeButton")
//        let customBackButton = UIBarButtonItem(image: homeButton, style: .done, target: self, action: nil)
//        self.navigationItem.leftBarButtonItem = customBackButton
        
    }
    
    private func getConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        timeLineBGImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(14)
            make.width.equalTo(view.frame.width - 38)
        }
        
        timeLineImageView.snp.makeConstraints { make in
            make.centerY.equalTo(timeLineBGImageView)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(10)
            make.width.equalTo(stripWidth)
        }
        
        timeImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLineBGImageView.snp.bottom).offset(10)
            make.height.equalTo(15)
        }
        
        mainBubbleImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(100)
        }


    }
    
    //MARK: Method
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc private func handleTimer() {
        updateProgressBar()
        
        elapsedSeconds += 1
        
        if elapsedSeconds % 3 == 0 {
            createRandomEnemyBubble()
        }
        
    }
    
    private func createRandomEnemyBubble() {
        let bubbleTypes: [BubbleType] = [.blue, .red, .green]
        let randomType = bubbleTypes[Int.random(in: 0..<bubbleTypes.count)]
        let bubble = createEnemyBubble(ofType: randomType)
        
        view.addSubview(bubble)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBubbleTap(_:)))
        bubble.addGestureRecognizer(tap)

        animateBubbleToCenter(bubble)
    }
    
    private func updateProgressBar() {
        viewModel.reduceTime()
        
        if viewModel.isTimeOver() {
            timer?.invalidate()
            timer = nil
            timeLineImageView.snp.updateConstraints { (make) in
                make.width.equalTo(0)
            }
        } else {
            let percentageWidth = (viewModel.secondsRemaining / 60.0) * Double(view.frame.size.width - 40)
            timeLineImageView.snp.updateConstraints { (make) in
                make.width.equalTo(percentageWidth)
            }
        }
        
        UIView.animate(withDuration: timerInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func handleBubbleTap(_ recognizer: UITapGestureRecognizer) {
        guard let tappedCircle = recognizer.view else { return }

        tappedCircle.tag -= 1

        if tappedCircle.tag == 0 {
            tappedCircle.removeFromSuperview()
        }
    }
    
    private func createEnemyBubble(ofType type: BubbleType) -> UIImageView {
        let bubble = UIImageView()
        
        switch type {
        case .blue:
            bubble.image = UIImage(named: "BlueBubble")
            bubble.frame.size = CGSize(width: 25, height: 25)
            bubble.tag = 1
        case .red:
            bubble.image = UIImage(named: "RedBubble")
            bubble.frame.size = CGSize(width: 50, height: 50)
            bubble.tag = 2
        case .green:
            bubble.image = UIImage(named: "GreenBubble")
            bubble.frame.size = CGSize(width: 75, height: 75)
            bubble.tag = 3
        }
        
        let side = viewModel.randomScreenSide()
        switch side {
        case .top:
            bubble.frame.origin.x = CGFloat.random(in: 0..<view.bounds.width)
            bubble.frame.origin.y = -bubble.frame.size.height
        case .left:
            bubble.frame.origin.x = -bubble.frame.size.width
            bubble.frame.origin.y = CGFloat.random(in: 0..<view.bounds.height)
        case .right:
            bubble.frame.origin.x = view.bounds.width
            bubble.frame.origin.y = CGFloat.random(in: 0..<view.bounds.height)
        case .bottom:
            bubble.frame.origin.x = CGFloat.random(in: 0..<view.bounds.width)
            bubble.frame.origin.y = view.bounds.height
        }
        
        bubble.isUserInteractionEnabled = true
        return bubble
    }
    
    private func animateBubbleToCenter(_ bubble: UIImageView) {
        let startPoint = bubble.center
        let endPoint = self.view.center
        let displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLinkAnimation))
        displayLink.preferredFramesPerSecond = 60
        displayLink.add(to: .current, forMode: .default)

        let animationInfo = BubbleAnimationInfo(startPoint: startPoint, endPoint: endPoint, bubble: bubble, displayLink: displayLink, startTime: CACurrentMediaTime())
        animations.append(animationInfo)
    }

    @objc private func handleDisplayLinkAnimation() {
        for (index, animation) in animations.enumerated().reversed() {
            guard let bubble = animation.bubble else {
                stopBubbleAnimation(at: index)
                continue
            }

            let elapsedTime = CACurrentMediaTime() - animation.startTime
            if elapsedTime >= animationDuration {
                stopBubbleAnimation(at: index)
                continue
            }

            let progress = elapsedTime / animationDuration
            let newX = animation.startPoint.x + (animation.endPoint.x - animation.startPoint.x) * CGFloat(progress)
            let newY = animation.startPoint.y + (animation.endPoint.y - animation.startPoint.y) * CGFloat(progress)
            bubble.center = CGPoint(x: newX, y: newY)
        }
    }
    
    private func stopBubbleAnimation(at index: Int) {
        animations[index].displayLink.invalidate()
        animations.remove(at: index)
        animationStartTime = nil
        bubbleStartPoint = nil
        bubbleEndPoint = nil
        currentAnimatingBubble = nil
    }

}


