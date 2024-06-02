//
//  Matrix.swift
//  DSPractice
//
//  Created by Ankita Kalangutkar on 17.03.24.
//

import Foundation

struct Matrix<T> {
    let rows: Int
    let columns: Int
    var grid: [T]
    
    init(rows: Int, columns: Int, value: T) {
        self.rows = rows
        self.columns = columns
        self.grid = Array(repeating: value, count: rows * columns)
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> T {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}
