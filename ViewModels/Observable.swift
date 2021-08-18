//
//  Observable.swift
//  SEBTask
//
//  Created by Vilius Bundulas on 2021-08-18.
//

import Foundation

class Observable<T> {

    typealias Closure = ((T)->())
    var value: T {
        didSet {
            DispatchQueue.main.async { [value] in
                self.binder?(value)
            }
        }
    }

    private var binder: Closure?

    init(_ value: T) {
        self.value = value
    }

    func bind(_ binding: @escaping Closure) {
        binding(value)
        self.binder = binding
    }
}
