//
//  Transaction.swift
//  SEBTask
//
//  Created by Vilius Bundulas on 2021-08-18.
//

import Foundation

typealias Transactions = [Transaction]

enum TransactionType: String, Codable {
    case credit = "credit"
    case debit = "debit"
}

struct Transaction: Codable {
    let id: String
    let counterPartyName: String
    let counterPartyAccount: String
    let type: TransactionType
    let amount: String
    let description: String
    let date: String
}

extension Transaction {
    
    var dateFromString : Date  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: date)!
        
        return date
    }
}

