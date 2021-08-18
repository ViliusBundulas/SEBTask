//
//  DependencyContainer.swift
//  SEBTask
//
//  Created by Vilius Bundulas on 2021-08-18.
//

import Foundation

protocol ViewControllersFactory {
    func startHomeViewController() -> HomeViewController
}

class DependencyContainer {
    lazy var apiManager = ApiManager()
}

extension DependencyContainer: ViewControllersFactory {
    func startHomeViewController() -> HomeViewController {
        let viewModel = HomeViewModel(apiManager: apiManager)
        return HomeViewController(viewModel: viewModel)
    }
}
