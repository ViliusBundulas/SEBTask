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
    var sumOfTransactionsAmount = Observable<Double?>(nil)
    var sumOfDebitTransactionsAmount = Observable<Double?>(nil)
    var sumOfCreditTransactionsAmount = Observable<Double?>(nil)
    var selectedSegmentControlIndex = Observable<Int>(0)
    
    func getTransactions() {
        self.isLoading.value = true
        self.apiManager.fetchTransactions { result in
            switch result {
            case .success(let result):
                self.transactions.value = result
                self.debitTransactions.value = result.filter { $0.type == .debit }
                self.creditTransactions.value = result.filter { $0.type == .credit }
                self.sumOfTransactionsAmount.value = result.map { Double($0.amount) ?? 0.0 }.reduce(0, +)
                self.sumOfDebitTransactionsAmount.value = self.debitTransactions.value?.map { Double($0.amount) ?? 0 }.reduce(0, +)
                self.sumOfCreditTransactionsAmount.value = self.creditTransactions.value?.map { Double($0.amount) ?? 0 }.reduce(0, +)
                self.isLoading.value = false
            case .failure:
                print("Failed to get transactions")
            }
        }
    }
    
    func getSelectedControlIndex(sender: UISegmentedControl) {
        self.selectedSegmentControlIndex.value = sender.selectedSegmentIndex
    }
}
