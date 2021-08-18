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
    
    func getTransactions() {
        self.apiManager.fetchTransactions { result in
            switch result {
            case .success(let result):
                result.forEach { item in
                    print(item.counterPartyName)
                }
            case .failure:
                print("Failed to get transactions")
            }
        }
    }
}
