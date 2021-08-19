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
        
        viewModel.debitTransactions.bind { _ in
            self.transactionListTableView.reloadData()
        }
        
        viewModel.creditTransactions.bind { _ in
            self.transactionListTableView.reloadData()
        }
        
        viewModel.selectedSegmentControlIndex.bind { _ in
            self.transactionListTableView.reloadData()
        }
        
        viewModel.isLoading.bind { isLoading in
            switch isLoading {
            case true:
                self.activityIndicatorView.startAnimating()
                self.transactionListTableView.isHidden = true
            case false:
                self.activityIndicatorView.stopAnimating()
                self.transactionListTableView.isHidden = false
            }
        }
    }
    
    //MARK: - App life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bindViewModel()
        setupViews()
        setupConstrains()
    }
    
    //MARK: - UI elements
    
    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["All Transactions", "Debit", "Credits"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return sc
    }()
    
    private lazy var transactionListTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TransactionListCell.self, forCellReuseIdentifier: "TransactionListCell")
        
        return tableView
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        
        return indicator
    }()
    
    //MARK: - Button actions
    
    @objc func handleSegmentChange(sender: UISegmentedControl) {
        viewModel.getSelectedControlIndex(sender: sender)
    }
    
    //MARK: - Setup views
    
    func setupViews() {
        view.addSubview(transactionListTableView)
        view.addSubview(activityIndicatorView)
        view.addSubview(segmentedControl)
    }
    
    //MARK: - Setup constrains
    
    func setupConstrains() {
        
        transactionListTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.bottom.equalTo(transactionListTableView.snp.top)
            make.leading.trailing.equalTo(transactionListTableView)
            make.height.equalTo(50)
        }
    }
}

//MARK: - Transaction list table view implementation

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch viewModel.selectedSegmentControlIndex.value {
        case 0:
            return viewModel.transactions.value?.count ?? 0
        case 1:
            return viewModel.debitTransactions.value?.count ?? 0
        case 2:
            return viewModel.creditTransactions.value?.count ?? 0
        default:
            return viewModel.transactions.value?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionListCell", for: indexPath) as! TransactionListCell
        
        switch viewModel.selectedSegmentControlIndex.value {
        case 0:
            makeCell(cell, at: indexPath, from: viewModel.transactions.value!)
        case 1:
            makeCell(cell, at: indexPath, from: viewModel.debitTransactions.value!)
        case 2:
            makeCell(cell, at: indexPath, from: viewModel.creditTransactions.value!)
        default:
            return cell
        }
        return cell
    }
}

    //MARK: - Helpers

private extension HomeViewController {
    
    func makeCell(_ cell: TransactionListCell, at index: IndexPath, from transactions: Transactions) {
        cell.nameLabel.text = transactions[index.row].counterPartyName
        cell.dateLabel.text = transactions[index.row].date
        cell.amountLabel.text = transactions[index.row].amount
    }
}
