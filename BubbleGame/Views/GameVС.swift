//
//  GameVС.swift
//  BubbleGame
//
//  Created by Dmitryi Velko on 17.10.2023.
//

import UIKit

class GameVC: UIViewController {
    
    //MARK: Property
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
//        navigationItem.hidesBackButton = true
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
        
        if elapsedSeconds % 5 == 0 {
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

        tappedCircle.removeFromSuperview()
//        tappedCircle.tag -= 1
//
//        if tappedCircle.tag == 0 {
//            tappedCircle.removeFromSuperview()
//        }
    }
    
    private func createEnemyBubble(ofType type: BubbleType) -> UIImageView {
        let bubble = UIImageView()
        switch type {
        case .blue:
            bubble.image = UIImage(named: "BlueBubble")
            bubble.frame = CGRect(x: Int.random(in: 0..<Int(view.bounds.width)), y: 0, width: 25, height: 25)
            bubble.isUserInteractionEnabled = true
            bubble.tag = 1
        case .red:
            bubble.image = UIImage(named: "RedBubble")
            bubble.frame = CGRect(x: Int.random(in: 0..<Int(view.bounds.width)), y: 0, width: 50, height: 50)
            bubble.isUserInteractionEnabled = true
            bubble.tag = 2
        case .green:
            bubble.image = UIImage(named: "GreenBubble")
            bubble.frame = CGRect(x: Int.random(in: 0..<Int(view.bounds.width)), y: 0, width: 75, height: 75)
            bubble.isUserInteractionEnabled = true
            bubble.tag = 3
        }
        
        return bubble
    }
    
//    private func animateBubbleToCenter(_ bubble: UIImageView) {
//        let path = UIBezierPath()
//        path.move(to: bubble.center)
//        let endPosition = CGPoint(x: view.center.x, y: view.center.y)
//        path.addLine(to: endPosition)
//        let moveAnimation = CAKeyframeAnimation(keyPath: "position")
//        moveAnimation.path = path.cgPath
//        moveAnimation.duration = 5.0
//        moveAnimation.fillMode = .forwards
//        moveAnimation.isRemovedOnCompletion = false
//        moveAnimation.delegate = self
//        bubble.layer.add(moveAnimation, forKey: "moveToCenter")
//    }
    
    private func animateBubbleToCenter(_ bubble: UIImageView) {
//        UIView.animate(withDuration: 5.0, animations: {
//            bubble.center = self.view.center
//        }) { (completed) in
//            if completed {
//                // Здесь вы можете выполнить любой дополнительный код после завершения анимации, если это необходимо.
//            }
//        }
        
//        UIView.animate(withDuration: 5.0, delay: 0, options: [.allowUserInteraction], animations: {
//                bubble.center = self.view.center
//            }, completion: nil)
        
        UIView.animate(withDuration: 5.0, delay: 0, options: [.allowUserInteraction], animations: {
                bubble.center = self.view.center
            }, completion: nil)
    }

}

//MARK: - CAAnimationDelegate
extension GameVC: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // Логика завершения анимации
    }
}
