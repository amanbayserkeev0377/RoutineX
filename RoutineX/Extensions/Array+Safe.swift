//
//  Array+Safe.swift
//  RoutineX
//
//  Created by Aman on 22/3/25.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
