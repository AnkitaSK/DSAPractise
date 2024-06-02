//
//  SupportingImplementations.swift
//  DSPractice
//
//  Created by Ankita Kalangutkar on 30/05/24.
//

import Foundation

func removeSmallerElements(array: [Int], element: Int) -> [Int] {
    var result = array
    result.removeAll{ $0 < element }
    result.append(element)
    return result
}
