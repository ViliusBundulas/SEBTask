//
//  HomeViewController.swift
//  SEBTask
//
//  Created by Vilius Bundulas on 2021-08-18.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Observable data binding
    
    func bindViewModel() {
        viewModel.transactions.bind { _ in
            self.transactionListTableView.reloadData()
        }
    }
    
    //MARK: - App life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupConstrains()
        
        view.addSubview(transactionListTableView)

        view.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
    }
    
    //MAKR: - UI elements
    
    private lazy var transactionListTableView: UITableView = {
       let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TransactionListCell.self, forCellReuseIdentifier: "TransactionListCell")
        
        return tableView
    }()
    
    //MARK: - Setup constrains
    
    func setupConstrains() {
        transactionListTableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(view)
        }
    }
}

    //MARK: - Transaction list table view implementation

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.transactions.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionListCell", for: indexPath) as! TransactionListCell
        
        cell.nameLabel.text = viewModel.transactions.value?[indexPath.row].counterPartyName
        cell.dateLabel.text = viewModel.transactions.value?[indexPath.row].date
        cell.amountLabel.text = viewModel.transactions.value?[indexPath.row].amount
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}
