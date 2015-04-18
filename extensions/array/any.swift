//
//  any.swift
//
//  Created by Raul on 4/17/15.
//  Copyright (c) 2015 rauluranga. All rights reserved.
//

extension Array {
    
    func any(function: (T) -> Bool) -> Bool {
        for element in self {
            if function(element) {
               return true
            }
        }
        return false
    }
    
}