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


//MARK: Возвращение непрозрачного типа
print("\n//Возвращение непрозрачного типа")

struct Square: Shape {
    var size: Int
    func draw() -> String {
        let line = String(repeating: "*", count: size)
        let result = Array<String>(repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}

let someSquare = Square(size: 3)
print(someSquare.draw())
print()

func makeTrapezoid() -> some Shape {
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = FlippedShape(shape: top)
    let trapezoid = JoinedShape(
        top: top,
        bottom: JoinedShape(top: middle, bottom: bottom)
    )
    return trapezoid
}
let trapezoid = makeTrapezoid()
print(trapezoid.draw())
print()
// *
// **
// **
// **
// **
// *

func flip<T: Shape>(_ shape: T) -> some Shape {
    return FlippedShape(shape: shape)
}
func join<T: Shape, U: Shape>(_ top: T, _ bottom: U) -> some Shape {
    JoinedShape(top: top, bottom: bottom)
}

let opaqueJoinedTriangles = join(smallTriangle, flip(smallTriangle))
print(opaqueJoinedTriangles.draw())
print()
// *
// **
// ***
// ***
// **
// *

//func invalidFlip<T: Shape>(_ shape: T) -> some Shape {
//    if shape is Square {
//        return shape // Error: return types don't match
//    }
//    return FlippedShape(shape: shape) // Error: return types don't match
//}

struct FlippedShape1<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        if shape is Square {
            return shape.draw()
        }
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}

func `repeat`<T: Shape>(shape: T, count: Int) -> some Collection {
    return Array<T>(repeating: shape, count: count)
}

print(`repeat`(shape: someSquare, count: 3))
