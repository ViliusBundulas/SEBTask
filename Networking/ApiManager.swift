//
//  ApiManager.swift
//  SEBTask
//
//  Created by Vilius Bundulas on 2021-08-18.
//

import Foundation
import Alamofire

class ApiManager {
    
    private let sourcesURL = "https://sheet.best/api/sheets/ebb5bfdc-efda-4966-9ecf-d2c171d6985a"
    
    func fetchTransactions(completion: @escaping (AFResult<Transactions>) -> Void) {
        
        AF.request(sourcesURL).responseDecodable { (response: AFDataResponse<Transactions>) in
            completion(response.result)
        }
    }
}
