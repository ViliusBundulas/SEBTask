//
//  HomeViewModel.swift
//  SEBTask
//
//  Created by Vilius Bundulas on 2021-08-18.
//

import Foundation
import UIKit

class HomeViewModel {
    private let apiManager: ApiManager
    
    init(apiManager: ApiManager) {
        self.apiManager = apiManager
        getTransactions()
    }
    var isLoading = Observable<Bool>(false)
    var transactions = Observable<Transactions?>(nil)
    var debitTransactions = Observable<Transactions?>(nil)
    var creditTransactions = Observable<Transactions?>(nil)
    var sumOfDebitTransactionsAmount = Observable<Double?>(nil)
    var sumOfCreditTransactionsAmount = Observable<Double?>(nil)
    var currentBallance = Observable<Double?>(nil)
    var selectedSegmentControlIndex = Observable<Int>(0)
    
    func getTransactions() {
        self.isLoading.value = true
        self.apiManager.fetchTransactions { result in
            switch result {
            case .success(let result):
                self.sortAllTransactions(from: result)
                self.sortDebitTransactions(from: result)
                self.sortCreditTransactions(from: result)
                self.sumDebitTransactions(from: result)
                self.sumCreditTransactions(from: result)
                self.getCurrentBalance()
                self.isLoading.value = false
            case .failure:
                print("Failed to get transactions")
            }
        }
    }
    
    func getSelectedControlIndex(sender: UISegmentedControl) {
        self.selectedSegmentControlIndex.value = sender.selectedSegmentIndex
    }
    
    func getCurrentBalance() {
        self.currentBallance.value =
            Double(self.sumOfDebitTransactionsAmount.value!) - Double(self.sumOfCreditTransactionsAmount.value!)
    }
    
    func sortAllTransactions(from result: Transactions) {
        self.transactions.value = result.sorted(by: { $0.dateFromString > $1.dateFromString })
    }
    
    func sortDebitTransactions(from result: Transactions) {
        self.debitTransactions.value = result
            .filter { $0.type == .debit }
            .sorted(by: { $0.dateFromString > $1.dateFromString })
    }
    
    func sortCreditTransactions(from result: Transactions) {
        self.creditTransactions.value = result
            .filter { $0.type == .credit }
            .sorted(by: { $0.dateFromString > $1.dateFromString })
    }
    
    func sumDebitTransactions(from result: Transactions) {
        self.sumOfDebitTransactionsAmount.value = self.debitTransactions.value?
            .map { Double($0.amount) ?? 0 }
            .reduce(0, +)
    }
    
    func sumCreditTransactions(from result: Transactions) {
        self.sumOfCreditTransactionsAmount.value = self.creditTransactions.value?
            .map { Double($0.amount) ?? 0 }
            .reduce(0, +)
    }
}
