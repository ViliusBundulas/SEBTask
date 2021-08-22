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
        
        viewModel.currentBallance.bind { value in
            self.informationView.balanceLabel.text = "\(value ?? .zero)" + " Eur"
        }
        
        viewModel.selectedSegmentControlIndex.bind { index in
            self.transactionListTableView.reloadData()
            
            switch index {
            case 0:
                self.informationView.balanceLabel.text =
                    "\(self.viewModel.currentBallance.value ?? .zero)" + " Eur"
                self.informationView.descriptionLabel.text = "Current balance"
            case 1:
                self.informationView.balanceLabel.text =
                    "\(self.viewModel.sumOfDebitTransactionsAmount.value ?? .zero)" + " Eur"
                self.informationView.descriptionLabel.text = "Sum of debits"
            case 2:
                self.informationView.balanceLabel.text =
                    "\(self.viewModel.sumOfCreditTransactionsAmount.value ?? .zero)" + " Eur"
                self.informationView.descriptionLabel.text = "Sum of credits"
            default:
                self.informationView.balanceLabel.text =
                    "\(self.viewModel.currentBallance.value ?? .zero)" + " Eur"
            }
        }
        
        viewModel.isLoading.bind { isLoading in
            switch isLoading {
            case true:
                self.activityIndicatorView.startAnimating()
                self.transactionListTableView.isHidden = true
                self.view.alpha = 0.6
                self.informationView.balanceLabel.isHidden = true
            case false:
                self.activityIndicatorView.stopAnimating()
                self.transactionListTableView.isHidden = false
                self.informationView.balanceLabel.isHidden = false
                self.view.alpha = 1
            }
        }
    }
    
    //MARK: - App life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        bindViewModel()
        setupViews()
        setupConstrains()
    }
    
    //MARK: - UI elements
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["All Transactions", "Debits", "Credits"])
        segmentedControl.selectedSegmentIndex = .zero
        segmentedControl.backgroundColor = #colorLiteral(red: 0.8697404265, green: 0.8645706773, blue: 0.8737145066, alpha: 1)
        segmentedControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return segmentedControl
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
    
    private let informationView = InformationView()
    
    //MARK: - Button actions
    
    @objc func handleSegmentChange(sender: UISegmentedControl) {
        viewModel.getSelectedControlIndex(sender: sender)
    }
    
    //MARK: - Setup views
    
    func setupViews() {
        view.addSubview(transactionListTableView)
        view.addSubview(activityIndicatorView)
        view.addSubview(segmentedControl)
        view.addSubview(informationView)
    }
    
    //MARK: - Setup constrains
    
    func setupConstrains() {
        
        transactionListTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view)
            make.height.equalTo(view.snp.height).multipliedBy(0.7)
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.bottom.equalTo(transactionListTableView.snp.top)
            make.leading.trailing.equalTo(transactionListTableView)
            make.height.equalTo(30)
        }
        
        informationView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(segmentedControl.snp.top)
        }
    }
}

//MARK: - Transaction list table view implementation

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch viewModel.selectedSegmentControlIndex.value {
        case 0:
            return viewModel.transactions.value?.count ?? .zero
        case 1:
            return viewModel.debitTransactions.value?.count ?? .zero
        case 2:
            return viewModel.creditTransactions.value?.count ?? .zero
        default:
            return viewModel.transactions.value?.count ?? .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionListCell", for: indexPath) as! TransactionListCell
        
        switch viewModel.selectedSegmentControlIndex.value {
        case 0:
            switch viewModel.transactions.value?[indexPath.row].type {
            case .credit:
                configureCreditTransactionCell(cell, at: indexPath, from: viewModel.transactions.value!, with: #colorLiteral(red: 1, green: 0.2777053714, blue: 0.3239941895, alpha: 1))
            case .debit:
                configureDebitTransactionCell(cell, at: indexPath, from: viewModel.transactions.value!, with: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
            default:
                return cell
            }
        case 1:
            configureDebitTransactionCell(cell, at: indexPath, from: viewModel.debitTransactions.value!, with: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
        case 2:
            configureCreditTransactionCell(cell, at: indexPath, from: viewModel.creditTransactions.value!, with: #colorLiteral(red: 1, green: 0.2777053714, blue: 0.3239941895, alpha: 1))
        default:
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

    //MARK: - Helpers

extension HomeViewController {
    
    func configureCreditTransactionCell(
        _ cell: TransactionListCell,
        at index: IndexPath,
        from transactions: Transactions,
        with color: UIColor
    ) {
        cell.amountLabel.textColor = color
        cell.amountLabel.text = "-" + transactions[index.row].amount + " Eur"
        cell.nameLabel.text = transactions[index.row].counterPartyName
        cell.dateLabel.text = transactions[index.row].date
    }
    
    func configureDebitTransactionCell(
        _ cell: TransactionListCell,
        at index: IndexPath,
        from transactions: Transactions,
        with color: UIColor
    ) {
        cell.amountLabel.textColor = color
        cell.amountLabel.text = "+" + transactions[index.row].amount + " Eur"
        cell.nameLabel.text = transactions[index.row].counterPartyName
        cell.dateLabel.text = transactions[index.row].date
    }
}
