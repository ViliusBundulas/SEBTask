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
        let sc = UISegmentedControl(items: ["All Transactions", "Credits", "Debits"])
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
            make.height.equalTo(30)
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
            return viewModel.creditTransactions.value?.count ?? 0
        case 2:
            return viewModel.debitTransactions.value?.count ?? 0
        default:
            return viewModel.transactions.value?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionListCell", for: indexPath) as! TransactionListCell
        
        switch viewModel.selectedSegmentControlIndex.value {
        case 0:
            if viewModel.transactions.value?[indexPath.row].type == .credit {
                cell.amountLabel.text = "+" + (viewModel.transactions.value?[indexPath.row].amount)! + " Eur"
                cell.amountLabel.textColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                cell.nameLabel.text = viewModel.transactions.value?[indexPath.row].counterPartyName
                cell.dateLabel.text = viewModel.transactions.value?[indexPath.row].date
            } else if viewModel.transactions.value?[indexPath.row].type == .debit {
                cell.amountLabel.text = "-" + (viewModel.transactions.value?[indexPath.row].amount)! + " Eur"
                cell.amountLabel.textColor = #colorLiteral(red: 1, green: 0.2777053714, blue: 0.3239941895, alpha: 1)
                cell.nameLabel.text = viewModel.transactions.value?[indexPath.row].counterPartyName
                cell.dateLabel.text = viewModel.transactions.value?[indexPath.row].date
            }
        case 1:
            cell.amountLabel.textColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            cell.amountLabel.text = "+" + (viewModel.creditTransactions.value?[indexPath.row].amount)! + " Eur"
            cell.nameLabel.text = viewModel.creditTransactions.value?[indexPath.row].counterPartyName
            cell.dateLabel.text = viewModel.creditTransactions.value?[indexPath.row].date

        case 2:
            cell.amountLabel.textColor = #colorLiteral(red: 1, green: 0.2777053714, blue: 0.3239941895, alpha: 1)
            cell.amountLabel.text = "-" + (viewModel.debitTransactions.value?[indexPath.row].amount)! + " Eur"
            cell.nameLabel.text = viewModel.debitTransactions.value?[indexPath.row].counterPartyName
            cell.dateLabel.text = viewModel.debitTransactions.value?[indexPath.row].date
        default:
            return cell
        }
        return cell
    }
}
