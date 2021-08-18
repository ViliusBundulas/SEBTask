//
//  Transaction.swift
//  SEBTask
//
//  Created by Vilius Bundulas on 2021-08-18.
//

import Foundation

typealias Transactions = [Transaction]

struct Transaction: Codable {
    let id: String
    let counterPartyName: String
    let counterPartyAccount: String
    let type: TransactionType
    let amount: String
    let description: String
    let date: String
}

enum TransactionType: String, Codable {
    case credit = "credit"
    case debit = "debit"
}
