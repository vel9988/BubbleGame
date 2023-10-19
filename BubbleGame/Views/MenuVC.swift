//
//  MenuVC.swift
//  BubbleGame
//
//  Created by Dmitryi Velko on 17.10.2023.
//

import UIKit
import SafariServices
import SnapKit

class MenuVC: UIViewController {
    
    private let viewModel = GameViewModel()
    private var isHardMode: Bool = false
    
    //MARK: Subviews
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Menu")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let startGameButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "PlayButton"), for: .normal)
        return button
    }()
    
    private let privacyPolicyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "RulesButton"), for: .normal)
        return button
    }()
    
    private let hardButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "HardModeButtonOff"), for: .normal)
        return button
    }()
    
    //MARK: LiveCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getConstraints()
    }
    
    //MARK: Setup
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(startGameButton)
        view.addSubview(privacyPolicyButton)
        view.addSubview(hardButton)
        
        startGameButton.addTarget(self, action: #selector(startGameTapped), for: .touchUpInside)
        privacyPolicyButton.addTarget(self, action: #selector(privacyPolicyTapped), for: .touchUpInside)
        
        hardButton.addTarget(self, action: #selector(hardButtonTapped), for: .touchUpInside)
    }
    
    private func getConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        startGameButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(110)
            make.width.equalTo(146)
            make.height.equalTo(53)
        }
        
        privacyPolicyButton.snp.makeConstraints { make in
            make.centerX.equalTo(startGameButton)
            make.top.equalTo(startGameButton.snp.bottom).offset(20)
            make.width.equalTo(146)
            make.height.equalTo(53)
        }
        
        hardButton.snp.makeConstraints { make in
            make.centerX.equalTo(startGameButton)
            make.top.equalTo(privacyPolicyButton.snp.bottom).offset(60)
            make.width.equalTo(186)
            make.height.equalTo(80)
        }

    }
    
    //MARK: Method
    @objc private func startGameTapped() {
        viewModel.secondsRemaining = 60.0
        let vc = GameVC()
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func privacyPolicyTapped() {
        guard let url = URL(string: "https://www.freeprivacypolicy.com/blog/privacy-policy-url/") else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    @objc private func hardButtonTapped() {
        isHardMode.toggle()
        viewModel.animationDuration = isHardMode ? 2.0 : 5.0
        
        let buttonImageName = isHardMode ? "HardModeButtonOn" : "HardModeButtonOff"
        hardButton.setImage(UIImage(named: buttonImageName), for: .normal)

    }
    
}
