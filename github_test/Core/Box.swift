//
//  Box.swift
//  github_test
//
//  Created by Shokhzod on 08/07/22.
//

import UIKit

final class Box<T> {
  //1
  typealias Listener = (T) -> Void
  var listener: Listener?
  //2
  var value: T {
    didSet {
      listener?(value)
    }
  }
  //3
  init(_ value: T) {
    self.value = value
  }
  //4
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}

class Stacks {
    var messages = Box([String]())
    var errors = Box([Error]())
}
