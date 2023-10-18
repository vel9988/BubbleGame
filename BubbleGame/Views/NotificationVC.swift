//
//  NotificationVC.swift
//  BubbleGame
//
//  Created by Dmitryi Velko on 18.10.2023.
//

import UIKit

class NotificationVC: UIViewController {
    
    //MARK: Subviews
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Menu")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let notificationTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Allow notifications about bonuses and promos"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let notificationTextTwoLabel: UILabel = {
        let label = UILabel()
        label.text = "Stay tuned with best offers from our casino"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor(red: 0.729, green: 0.729, blue: 0.729, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let acceptButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Yes, I Want Bonuses!", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.tintColor = UIColor(red: 0.729, green: 0.729, blue: 0.729, alpha: 1)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavBar()
        getConstraints()
        
    }
    
    //MARK: Setup
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(notificationTextLabel)
        view.addSubview(notificationTextTwoLabel)
        view.addSubview(acceptButton)
        view.addSubview(skipButton)
        
        acceptButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        
    }
    
    private func setupNavBar() {
        navigationItem.hidesBackButton = true
    }
    
    private func getConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        notificationTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(150)
            make.width.equalToSuperview().offset(-40)
        }
        
        notificationTextTwoLabel.snp.makeConstraints { make in
            make.centerX.equalTo(notificationTextLabel)
            make.top.equalTo(notificationTextLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-40)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.centerX.equalTo(notificationTextLabel)
            make.top.equalTo(notificationTextTwoLabel).offset(40)
            make.width.equalTo(view.bounds.width - 40)
            make.height.equalTo(60)
        }
        
        skipButton.snp.makeConstraints { make in
            make.centerX.equalTo(acceptButton)
            make.top.equalTo(acceptButton.snp.bottom).offset(20)
        }
        


    }
    
    //MARK: Method

    @objc private func acceptTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    



}
