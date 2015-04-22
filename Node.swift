//
//  Node.swift
//  EtchASketchSimulator
//
//  Created by Bri Chapman on 2/21/15.
//  Copyright (c) 2015 edu.illinois.bchapman. All rights reserved.
//

import Foundation

class Node : NSObject {
    var xCoordinate : Int = 0
    var yCoordinate : Int = 0
    var selected : Bool
    var connections : [Node] = [Node]()
    
    init(xCoordinate:Int, yCoordinate:Int, connections:[Node]?){
        self.xCoordinate = xCoordinate
        self.yCoordinate = yCoordinate
        self.connections = connections!
        self.selected = false 
    }
    
//    func useConnection(node:Node) -> Node{
//        println("connections.count = \(connections.count)")
//        for i in 0...connections.count {
//            if (i < connections.count){
//                if connections[i] == node {
//                    connections.removeAtIndex(i)
//                    usedConnections.append(node)
//                    break
//                }
//            }
//        }
//        for i in 0...node.connections.count {
//            if (i < node.connections.count){
//                if node.connections[i] == self {
//                    node.connections.removeAtIndex(i)
//                    node.usedConnections.append(node)
//                    break
//                }
//            }
//        }
//        return node
//    }
    
    override var description : String {
        return "(\(xCoordinate), \(yCoordinate)) - selected: \(selected)"
    }
    
}
