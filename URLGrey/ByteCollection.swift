//
//  ByteCollection.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 1/10/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation

public typealias Byte = UInt8

public protocol ByteCollection: CollectionType {
    
    typealias Element: UnsignedIntegerType
    
}
