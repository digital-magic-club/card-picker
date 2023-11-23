//
//  File.swift
//  CardPicker
//
//  Created by Guillaume Bellut on 23/11/2023.
//  Copyright © 2023 Digital Magic Club. All rights reserved.
//

import Foundation

extension Collection {
  /// Returns the element at the specified index iff it is within bounds, otherwise nil.
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
