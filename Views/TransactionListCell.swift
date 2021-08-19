//
//  TransactionListCell.swift
//  SEBTask
//
//  Created by Vilius Bundulas on 2021-08-19.
//

import Foundation
import UIKit
import SnapKit

class TransactionListCell: UITableViewCell {
    
    //MARK: - UI elements
    
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    let amountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Cell configuration
    
    func configureCell() {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(amountLabel)
        
        setupConstrains()
        configureDateLabel()
        configureAmountLabel()
    }
    
    //MARK: - Setup constrains
    
    func setupConstrains() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(5)
            make.leading.equalTo(contentView).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.leading.equalTo(nameLabel)
            make.width.equalTo(nameLabel)
            make.bottom.equalTo(contentView).inset(5)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.centerY.equalTo(contentView)
        }
    }
}

    //MARK: - COnfigure UI elements

private extension TransactionListCell {
    
    func configureDateLabel() {
        self.dateLabel.alpha = 0.6
    }
    
    func configureAmountLabel() {
        self.amountLabel.font = UIFont.boldSystemFont(ofSize: self.amountLabel.font.pointSize)
        self.amountLabel.textAlignment = .right
    }
}
