//
//  Array+Shift.swift
//  Runner
//
//  Created by Andrés Pesate on 09/11/2020.
//

import Foundation

extension Array {
  static func <<(array: Array<Element>, qty: Int) -> Array<Element> {
    var newArr = array[qty..<array.count]
    newArr += array[0..<qty]
    return Array(newArr)
  }

  static func >>(array: Array<Element>, qty: Int) -> Array<Element> {
    var newArr = array[(array.count - qty)..<array.count]
    newArr += array[0..<(array.count - qty)]
    return Array(newArr)
  }
}
