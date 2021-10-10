//
//  main.swift
//  Opaque Types
//
//  Created by 2lup on 09.10.2021.
//

import Foundation

print("Hello, World!")


//MARK: Проблема, которую решают непрозрачные типы
print("\n//Проблема, которую решают непрозрачные типы")

protocol Shape {
    func draw() -> String
}

struct Triangle: Shape {
    var size: Int
    func draw() -> String {
        var result: [String] = []
        for length in 1...size {
            result.append(String(repeating: "*", count: length))
        }
        return result.joined(separator: "\n")
    }
}
let smallTriangle = Triangle(size: 3)
print(smallTriangle.draw())
print()
// *
// **
// ***

struct FlippedShape<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        //split(separator: "\n") возвращает строку как коллекцию, "\n" является границами разбивки на элементы
        let lines = shape.draw().split(separator: "\n")
        //print(lines)
        //reversed() возвращает элементы коллекции в обратном порядке
        //joined(separator: "\n") возвращает элементы коллекции как строку, между элементами которого ставит "\n"
        return lines.reversed().joined(separator: "\n")
    }
}
let flippedTriangle = FlippedShape(shape: smallTriangle)
print(flippedTriangle.draw())
print()
// ***
// **
// *


struct JoinedShape<T: Shape, U: Shape>: Shape {
    var top: T
    var bottom: U
    func draw() -> String {
        return top.draw() + "\n" + bottom.draw()
    }
}

let joinedTriangles = JoinedShape(top: smallTriangle, bottom: flippedTriangle)
print(joinedTriangles.draw())
print()
// *
// **
// ***
// ***
// **
// *

let joinedTriangles1 = JoinedShape(top: smallTriangle, bottom: smallTriangle)
print(joinedTriangles1.draw())
print()
// *
// **
// ***
// *
// **
// ***
