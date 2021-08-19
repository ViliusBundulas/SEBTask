//
//  HomeViewModel.swift
//  SEBTask
//
//  Created by Vilius Bundulas on 2021-08-18.
//

import Foundation

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
    
    func getTransactions() {
        self.isLoading.value = true
        self.apiManager.fetchTransactions { result in
            switch result {
            case .success(let result):
                self.transactions.value = result
                self.debitTransactions.value = result.filter { $0.type == .debit }
                self.creditTransactions.value = result.filter { $0.type == .credit }
                self.isLoading.value = false
            case .failure:
                print("Failed to get transactions")
            }
        }
    }
}
