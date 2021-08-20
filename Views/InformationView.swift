//
//  BalanceInformationView.swift
//  SEBTask
//
//  Created by Vilius Bundulas on 2021-08-20.
//

import Foundation
import UIKit

class InformationView: UIView {
    
    //MARK: - UI elements
    
    let balanceLabel = UILabel()
    let descriptionLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        setupConstrains()
        configureBalanceLabel()
        configureDescriptionLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup views
    
    func setupView() {
        self.addSubview(balanceLabel)
        self.addSubview(descriptionLabel)
    }
    
    //MARK: - Setup constrains
    
    func setupConstrains() {
        balanceLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.2)
            make.width.equalTo(self)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(balanceLabel.snp.top).inset(10)
        }
    }
    
    //MARK: - Congifure UI elements
    
    func configureBalanceLabel() {
        balanceLabel.textAlignment = .center
        balanceLabel.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    func configureDescriptionLabel() {
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        descriptionLabel.alpha = 0.7
        descriptionLabel.text = "Current balance"
    }
}
