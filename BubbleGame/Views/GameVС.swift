//
//  GameVС.swift
//  BubbleGame
//
//  Created by Dmitryi Velko on 17.10.2023.
//

import UIKit

class GameVC: UIViewController {
    
    //MARK: Property
    var viewModel = GameViewModel()
    
    private var animations: [BubbleAnimationInfo] = []
    private var stripWidth: CGFloat = 0
    private var currentLives = 4
    private let timerInterval = 1.0
    private var elapsedSeconds = 0
    private var timer: Timer?
    
    private var heartImageViews: [UIImageView] = []
    
    private var hasExecutedGameOver = false
    
    //MARK: Subviews
    private let fullHeartImage = UIImage(named: "FullHeart")
    private let emptyHeartImage = UIImage(named: "EmptyHeart")
    
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
    
    private let liveImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Live")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let mainBubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MainBubble")
        return imageView
    }()
    
    private let containerHeartView: UIView = {
        let view = UIView()
        return view
    }()
    
    let gameOverImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "GameOver"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let youWinImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "YouWin"))
        imageView.contentMode = .scaleAspectFill
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
        view.addSubview(liveImageView)
        view.addSubview(containerHeartView)
        
        stripWidth = self.view.frame.width - 40
        
        setupContainerHeartView()
        
    }
    
    private func setupNavBar() {
        navigationItem.hidesBackButton = true
        let homeImage = UIImage(named: "HomeButton")
        let homeButton = UIButton(type: .custom)
        homeButton.setImage(homeImage, for: .normal)
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        let homeBarButton = UIBarButtonItem(customView: homeButton)
        self.navigationItem.leftBarButtonItem = homeBarButton
    }
    
    private func setupContainerHeartView() {
        for i in 0..<currentLives {
            let heartImageView = UIImageView(image: fullHeartImage)
            heartImageView.frame = CGRect(x: 0 + i * 25, y: 0, width: 20, height: 20)
            heartImageViews.append(heartImageView)
            containerHeartView.addSubview(heartImageView)
        }
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
            make.height.width.equalTo(140)
        }
        
        liveImageView.snp.makeConstraints { make in
            make.centerX.equalTo(mainBubbleImageView)
            make.centerY.equalTo(mainBubbleImageView).offset(-30)
            make.height.equalTo(15)
        }
        
        containerHeartView.snp.makeConstraints { make in
            make.centerX.equalTo(mainBubbleImageView).offset(-45)
            make.centerY.equalTo(mainBubbleImageView)
        }
        
    }
    
    //MARK: Method
    @objc private func homeButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // Запуск таймера, который вызывает handleTimer каждую секунду
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func handleTimer() {
        // Обновление прогресса времени
        updateProgressBar()
        
        // Увеличиваем счетчик прошедших секунд
        elapsedSeconds += 1
        
        // Каждую секунду создаем случайный пузырь-врага
        createRandomEnemyBubble()
        
        // Проверяем, не истекло ли время игры
        if viewModel.isTimeOver() {
            timer?.invalidate()
            timer = nil
            
            youWinImageView.frame.size = view.bounds.size
            youWinImageView.center = view.center
            view.addSubview(youWinImageView)
            
            // Переходим в NotificationVC после 3 секунд
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                let vc = NotificationVC()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    private func createRandomEnemyBubble() {
        // Создаем пузырь случайного типа и анимируем его к центру экрана
        let bubbleTypes: [BubbleType] = [.blue, .red, .green]
        let randomType = bubbleTypes[Int.random(in: 0..<bubbleTypes.count)]
        let bubble = createEnemyBubble(ofType: randomType)
        
        view.addSubview(bubble)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleBubbleTap(_:)))
        bubble.addGestureRecognizer(tap)

        animateBubbleToCenter(bubble)
    }
    
    private func updateProgressBar() {
        // Уменьшаем время игры и обновляем вид прогресс-бара
        viewModel.reduceTime()
        
        let percentageWidth = (viewModel.secondsRemaining / 60.0) * Double(view.frame.size.width - 40)
        timeLineImageView.snp.updateConstraints { (make) in
            make.width.equalTo(percentageWidth)
        }
        
        UIView.animate(withDuration: timerInterval) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func handleBubbleTap(_ recognizer: UITapGestureRecognizer) {
        // Обрабатываем нажатие на пузырь: уменьшаем тэг, и если он равен 0, удаляем пузырь
        guard let tappedCircle = recognizer.view else { return }

        tappedCircle.tag -= 1

        if tappedCircle.tag == 0 {
            tappedCircle.removeFromSuperview()
        }
    }
    
    private func createEnemyBubble(ofType type: BubbleType) -> UIImageView {
        // Создаем пузырь-врага определенного типа и устанавливаем его начальное положение на экране
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
        // Запускаем анимацию движения пузыря к центру экрана
        let startPoint = bubble.center
        let endPoint = self.view.center
        let displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLinkAnimation))
        displayLink.preferredFramesPerSecond = 60
        displayLink.add(to: .current, forMode: .default)

        let animationInfo = BubbleAnimationInfo(startPoint: startPoint, endPoint: endPoint, bubble: bubble, displayLink: displayLink, startTime: CACurrentMediaTime())
        animations.append(animationInfo)
    }

    @objc private func handleDisplayLinkAnimation() {
        // Обновляем позицию пузыря на каждом кадре анимации и проверяем, не достиг ли он центра
        for (index, animation) in animations.enumerated().reversed() {
            guard let bubble = animation.bubble else {
                stopBubbleAnimation(at: index)
                continue
            }

            let elapsedTime = CACurrentMediaTime() - animation.startTime
            if elapsedTime >= viewModel.animationDuration {
                stopBubbleAnimation(at: index)
                continue
            }

            let progress = elapsedTime / viewModel.animationDuration
            let newX = animation.startPoint.x + (animation.endPoint.x - animation.startPoint.x) * CGFloat(progress)
            let newY = animation.startPoint.y + (animation.endPoint.y - animation.startPoint.y) * CGFloat(progress)
            bubble.center = CGPoint(x: newX, y: newY)
            
            let distanceToCenter = sqrt(pow(bubble.center.x - view.center.x, 2) + pow(bubble.center.y - view.center.y, 2))
            if distanceToCenter < 70.0 {
                bubble.removeFromSuperview()
                decreaseLife()
            }
        }
    }
    
    private func stopBubbleAnimation(at index: Int) {
        // Останавливаем анимацию пузыря и удаляем его из списка активных анимаций
        animations[index].displayLink.invalidate()
        animations.remove(at: index)
    }
    
    func decreaseLife() {
        // Уменьшаем количество оставшихся жизней и проверяем, не окончена ли игра
        if currentLives > 0 {
            currentLives -= 1
            heartImageViews[currentLives].image = emptyHeartImage
        }

        if currentLives == 0 && !hasExecutedGameOver {
            timer?.invalidate()
            timer = nil
            
            gameOverImageView.frame.size = view.bounds.size
            gameOverImageView.center = view.center
            view.addSubview(gameOverImageView)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                let vc = NotificationVC()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            hasExecutedGameOver = true
        }
    }

}


