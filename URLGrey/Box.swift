//
//  Box.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 10/21/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

final class Box<T> {
    private let boxed: T
    
    init(_ value : T) {
        self.boxed = value
    }
    
    var value: T {
        return boxed
    }
}
