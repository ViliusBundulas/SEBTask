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
    
    var transactions = Observable<Transactions?>(nil)
    
    func getTransactions() {
        self.apiManager.fetchTransactions { result in
            switch result {
            case .success(let result):
                self.transactions.value = result
            case .failure:
                print("Failed to get transactions")
            }
        }
    }
}


//                print(self.creditTransactions.value!)
//                let sum = numbers.reduce(0) { $0 + (Double($1) ?? .zero) }
//                print(sum)
