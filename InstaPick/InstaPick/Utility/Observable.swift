//
//  Observable.swift
//  InstaPick
//
//  Created by Vyas, Rajat on 12/02/22.
//

import Foundation

class Observable<T> {
    
    var change: ((T?) -> Void)?
    
    var value: T? {
        didSet {
            change?(value)
        }
    }
    
    func bind(_ closure: @escaping (T?) -> Void) {
        change = closure
    }
}
