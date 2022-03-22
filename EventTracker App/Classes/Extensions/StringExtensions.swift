//
//  StringExtensions.swift
//  EventTracker App
//
//  Created by Nitesh on 22/03/22.
//

import Foundation

import Foundation

extension String {
    
    var isWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}
