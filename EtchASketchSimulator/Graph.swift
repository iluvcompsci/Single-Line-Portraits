//
//  GraphConstructor.swift
//  EtchASketchSimulator
//
//  Created by Bri Chapman on 2/21/15.
//  Copyright (c) 2015 edu.illinois.bchapman. All rights reserved.
//

import UIKit

class Graph: NSObject {
    var nodes: [Node] = [Node]()
    var orderedNodes = [Node]()
    
    var oddDegree : [Node]!
    
    var layout = Array<Array<Node?>>()
    var layoutWidth = 0
    var layoutHeight = 0
    var easWidth = 0
    var easHeight = 0
    
    var newWidthRatio : Float = 0
    var newHeightRatio : Float = 0
    
//    var adjacencyMatrix : [[Double]]!

    func constructGraph(image:(UIImage), width:Int, height:Int, boxWidth:Int, boxHeight:Int){
        easWidth = boxWidth
        easHeight = boxHeight
        
        var cgimage = image.CGImage
        var graphAspectRatio = height/width
        var boxAspectRatio = boxHeight/boxWidth
        
        var newWidth : Int
        var newHeight : Int
        var widthRatio: Float = (Float(boxWidth)/Float(width))

        var heightRatio: Float = (Float(boxHeight)/Float(height))
        
        if(boxAspectRatio > graphAspectRatio){
            newWidth = Int(ceil(widthRatio*Float(width)))
            newWidthRatio = (Float(newWidth)/Float(width))
            newHeight = Int(ceil(newWidthRatio*Float(height)))
        } else {
            newHeight = Int(ceil(heightRatio*Float(height)))
            newHeightRatio = (Float(newHeight)/Float(height))
            newWidth = Int(ceil(newHeightRatio*Float(width)))
        }
        
        println("image [\(CGImageGetWidth(cgimage)), \(CGImageGetHeight(cgimage))]")
        println("wh [\(width), \(height)]")
        println("bwh [\(boxWidth), \(boxHeight)]")


        //for every pixel in the image, place a node
        layoutWidth = newWidth
        layoutHeight = newHeight
        
        println("layout [\(layoutWidth), \(layoutHeight)]")
        var emptyNode:Node?

        layout = [[Node?]](count: easWidth, repeatedValue: [Node?](count: easHeight, repeatedValue:emptyNode))
        
        
//        for i in 0...easWidth {
//            layout.append([Node]())
//            for j in 0...easHeight {
//                var emptyNode:Node?
//                layout[i].append(emptyNode)
//            }
//        }
//        adjacencyMatrix = [[Double]]()
//        for i in 0...nodes.count+1 {
//            adjacencyMatrix.append([Double]())
//            for j in 0...nodes.count{
//                adjacencyMatrix[j].append(0)
//            }
//        }
//        
        placeNodeAtEveryBlackPixel(image)
        //keep the local horizontal and vertical extrema and remove vertices that aren’t really doing anything?? (use a modified convex hull/three penny algorithm)
        //add edges between the maxima and minima now, when we remove the ones between, to guarantee that the edge is constructed properly. (sort of pretend these edges aren’t there while constructing the rest of the graph)
        connectAll()
    }
    
//    func connectAll(){
//        while oddDegree.count > 0 {
//            var index = Int(arc4random()%UInt32(oddDegree.count))
//            var node1 = oddDegree[index]
//            var node2 = closestExistingVertex(oddDegree[index].xCoordinate, yCoordinate: oddDegree[0].xCoordinate, node:oddDegree[index])
//            if(node2 != nil){
//                if !alreadyConnected(node1, node2: node2!){
//                    connectNodes(node1, node2: node2!)
//                }
//            }
//        }
//    }
    
    func connectAll() -> [Node]{
        var set = NSMutableSet(array: nodes)
        var startVertex = nodes.first!
//
//        set.removeObject(startVertex)
//        var root = Node(xCoordinate: 0, yCoordinate: 0, connections: [Node]())
//        println(set)
        var orderedArray = [Node]()
//        var tuple = getMinimumCostRoute(startVertex, set: set, root:root)
//        println("final cost: \(tuple.cost)")
//        println("orderedArray: \(tuple.orderedArray)")
//        orderedNodes = tuple.orderedArray
//        orderedNodes.append(tuple.orderedArray.first!)
        while set.count > 1{
            set.removeObject(startVertex)
            var newStartVertex = closestNode(startVertex, set: set)
//            if (euclideanDistance(newStartVertex, node2: startVertex) < 100){
                orderedArray.append(startVertex)
//            }
            startVertex = newStartVertex
        }
        orderedNodes = orderedArray
        return orderedArray
    }

//    //held-karp-bellman TSP problem
//    func getMinimumCostRoute(startVertex: Node, set: NSMutableSet, root: Node) -> (cost: Double, orderedArray: [Node]) {
////        println("start vertex\(startVertex), root \(root), set.count \(set.count)")
////        if (set.count == 0){
////            //source node is assumed to be the first
////            root.selected = true
//////            root.connections.append(startVertex)
////            var distance = euclideanDistance(startVertex, node2: root)
////            var orderedArray = [Node]()
////            orderedArray.append(root)
////            return (distance, orderedArray)
////        }
//        
//        var totalCost : Double = 10000
//        var selectedNode : Node!
//        var ordered : [Node]!
//        var selectedOrderedPath = [Node]()
//        var newSet : NSMutableSet!
//        
//        for destination in set {
//            var nodeDest = destination as Node
//            selectedNode = closestNode(nodeDest, set: set)
////                var costOfVisitingCurrentNode : Double = euclideanDistance(root, node2: nodeDest)
////                    println("cost of visiting \(nodeDest.xCoordinate),\(nodeDest.yCoordinate) from \(root.xCoordinate),\(root.yCoordinate): \(costOfVisitingCurrentNode)")
////                    var newSet : NSMutableSet = NSMutableSet(set:set)
//                    //make a deep copy of everything in the set before the recursive call?
//            
//                    set.removeObject(selectedNode)
////                    var minPath = getMinimumCostRoute(startVertex, set: newSet, root: closestNode)
////                    for item in newSet {
////                        (item as Node).selected = false
////                    }
////                    var costOfVisitingOtherNodes = minPath.cost
////                    ordered = minPath.orderedArray
//            
////                    var currentCost : Double = costOfVisitingCurrentNode + costOfVisitingOtherNodes
//            
////                    if (currentCost < totalCost)
////                    {
////                        totalCost = currentCost
////                        selectedNode = nodeDest
////                        selectedOrderedPath = ordered
////                        println("going from (\(root.xCoordinate),\(root.yCoordinate)) to (\(selectedNode.xCoordinate),\(selectedNode.yCoordinate)): \(currentCost)")
////
////                    }
//            selectedOrderedPath.append(selectedNode)
//            
//        }
//        
////        for item in set {
////            (item as Node).selected = true
////        }
////        
////        selectedNode.selected = true
////        selectedOrderedPath.append(selectedNode)
//    
//
//        return (totalCost, selectedOrderedPath)
//        
//    }
    
    func closestNode(node:Node, set:NSMutableSet) -> Node {
        var minEuclideanDist : Double = 1000000
        var closestNodeInSet : Node!
        for item in set {
            var euclideanDist : Double = euclideanDistance(node, node2: item as! Node)
            if (euclideanDist < minEuclideanDist){
                minEuclideanDist = euclideanDist
                closestNodeInSet = item as! Node
            }
        }
//        println("the closest node to (\(node.xCoordinate),\(node.yCoordinate)) is (\(closestNodeInSet.xCoordinate),\(closestNodeInSet.yCoordinate)) with distance \(minEuclideanDist)")
        return closestNodeInSet
    }
//    func evenVertices() -> Bool{
//        for node in nodes{
//            if ((node.connections.count%2 != 0) || (node.connections.count == 0)) {
//                return false
//            }
//        }
//        return true
//    }
    
//    func orderVertices(root: Node, startNode: Node) -> [Node]{
//        orderedNodes = [Node]()
//        orderedNodes.append(startNode)
//        orderVerticesRecursiveUtil(root, queue:orderedNodes)
//        return orderedNodes
//    }
//    
//    func orderVerticesRecursiveUtil(root: Node, queue:[Node]){
//        if root.connections.count == 0 {
//            return
//        }
//        
//        for destination in root.connections {
//            if (destination.selected){
//                orderedNodes.append(destination)
//                orderVerticesRecursiveUtil(destination, queue:orderedNodes)
//            }
//        }
//    }

    func printConnections(node:Node){
        for aNode in node.connections{
            print("(\(aNode.xCoordinate), \(aNode.yCoordinate)),")
        }
        println()
    }
    
    func placeNodeAtEveryBlackPixel(image:(UIImage)){
        var cgimage : CGImageRef = image.CGImage
        var rawData : CFDataRef = CGDataProviderCopyData(CGImageGetDataProvider(cgimage))

        var buf : UnsafePointer<UInt8> = CFDataGetBytePtr(rawData)
        var length : Int = CFDataGetLength(rawData)
        
        var x = 0
        var y = 0
        var i : Int = 0
        while i<length
        {
            var r = buf[i+1]
            var g = buf[i+2]
            var b = buf[i+3]
            
            if (r == 0 && g == 0 && b == 0){
                var horizOffset : Int = 0
                var vertOffset : Int = 0
                
                if(layoutWidth < easWidth){
                    horizOffset = (easWidth - layoutWidth)/2
                }
                if(layoutHeight < easHeight){
                    vertOffset = (easHeight - layoutHeight)/2
                }
                
                var horiz : Int = Int(floor((Float(x)/Float(CGImageGetWidth(cgimage)))*Float(layoutWidth)))
                var vert : Int = Int(floor((Float(y)/Float(CGImageGetHeight(cgimage)))*Float(layoutHeight)))
                placeNodeAtIndex(horiz+horizOffset, verticalIndex: vert+vertOffset)
            }
            i+=4
            x++
            if x == Int(CGImageGetWidth(cgimage)) {
                y++
                x = 0
            }
        }
    }
    
    
    func placeNodeAtIndex(horizontalIndex:Int, verticalIndex:Int){
        
        let newNode = Node(xCoordinate: horizontalIndex,
            yCoordinate: verticalIndex,
            connections:[Node]())
        
//        addToOdd(newNode)
        
//        if let close = superCloseNode(horizontalIndex, yCoordinate: verticalIndex) {
//            if (close != newNode){
//                connectNodes(close, node2: newNode)
//            }
//        }
        
        nodes.append(newNode)
//        println("(\(horizontalIndex), \(verticalIndex))")
        layout[horizontalIndex][verticalIndex] = newNode
        
    }
    
    func euclideanDistance(node1:Node, node2:Node) -> Double{
        var x : Double = pow(Double(node1.xCoordinate - node2.xCoordinate), 2)
        var y : Double = pow(Double(node1.yCoordinate - node2.yCoordinate), 2)
        var dist = sqrt(x + y)
        return dist
    }
    
//    func closestExistingVertex(xCoordinate:Int, yCoordinate:Int, node:Node) -> Node? {
//        //closest existing vertex
//        var closestExistingVertex: Node?
//        var min : Int = 10000
//        println(oddDegree.count)
//        for eachNode in oddDegree {
//            let current = euclideanDistance(xCoordinate, yCoordinate: yCoordinate, node:eachNode)
//            if current < min && eachNode != node {
//                min = current
//                closestExistingVertex = eachNode
//            }
//        }
//        return closestExistingVertex?
//    }
    
//    func superCloseNode(xCoordinate:(Int), yCoordinate:(Int)) -> Node?{
//        //check in all directions and if there is a node one unit away, make that connection for sure. 
//        
//        var closeNode : Node?
//        if(xCoordinate < layoutWidth && yCoordinate < layoutHeight && xCoordinate >= 0 && yCoordinate >= 0){
//            if ((xCoordinate + 1) < layoutWidth){
//                if let current = layout[xCoordinate + 1][yCoordinate] {
//                    closeNode = current
//                }
//                if ((yCoordinate + 1) < layoutHeight){
//                    if let current = layout[xCoordinate + 1][yCoordinate + 1] {
//                        closeNode = current
//                    }
//                }
//                if ((yCoordinate - 1) >= 0){
//                    if let current = layout[xCoordinate + 1][yCoordinate - 1] {
//                        closeNode = current
//                    }
//                }
//            }
//            
//            if ((xCoordinate - 1) >= 0){
//                if ((yCoordinate + 1) < layoutHeight){
//                    if let current = layout[xCoordinate - 1][yCoordinate + 1] {
//                        closeNode = current
//                    }
//                }
//                if ((yCoordinate - 1) >= 0){
//                    if let current = layout[xCoordinate - 1][yCoordinate - 1] {
//                        closeNode = current
//                    }
//                }
//                if let current = layout[xCoordinate - 1][yCoordinate] {
//                    closeNode = current
//                }
//            }
//            
//            if ((yCoordinate + 1) < layoutHeight){
//                if let current = layout[xCoordinate][yCoordinate + 1] {
//                    closeNode = current
//                }
//            }
//            
//            if ((yCoordinate - 1) >= 0){
//                if let current = layout[xCoordinate][yCoordinate - 1] {
//                    closeNode = current
//                }
//            }
//
//        }
//        return closeNode
//    }
    
//    func connectNodes(node1:Node, node2:Node) {
//        if(node1 != node2){
//            node1.connections.append(node2)
//            println("connecting (\(node1.xCoordinate),\(node1.yCoordinate)) to (\(node2.xCoordinate),\(node2.yCoordinate)) so now (\(node1.xCoordinate),\(node1.yCoordinate))'s degree is \(node1.connections.count) and (\(node2.xCoordinate),\(node2.yCoordinate))'s degree is  \(node2.connections.count)")
//            node2.connections.append(node1)
//            println("connecting (\(node2.xCoordinate),\(node2.yCoordinate)) to (\(node1.xCoordinate),\(node1.yCoordinate)) so now (\(node2.xCoordinate),\(node2.yCoordinate))'s degree is \(node2.connections.count) and (\(node1.xCoordinate),\(node1.yCoordinate))'s degree is  \(node1.connections.count)")
//            
//            var node1Odd = (node1.connections.count%2 != 0)
//            var node2Odd = (node2.connections.count%2 != 0)
//            
//            if (node1Odd || node1.connections.count == 0){
//                addToOdd(node1)
//                println("adding (\(node1.xCoordinate),\(node1.yCoordinate))[\(node1.connections.count)] to odd degree[\(oddDegree.count)]")
//            } else {
//                removeNodeFromOdd(node1)
//                println("removing (\(node1.xCoordinate),\(node1.yCoordinate))[\(node1.connections.count)] from odd degree[\(oddDegree.count)]")
//            }
//            
//            if (node2Odd || node2.connections.count == 0){
//                addToOdd(node2)
//                println("adding (\(node2.xCoordinate),\(node2.yCoordinate))[\(node2.connections.count)] to odd degree[\(oddDegree.count)]")
//            } else {
//                removeNodeFromOdd(node2)
//                println("removing (\(node2.xCoordinate),\(node2.yCoordinate))[\(node2.connections.count)] from odd degree[\(oddDegree.count)]")
//            }
//            
//        }
//
//    }
    
//    func alreadyConnected(node1:Node, node2:Node) -> Bool{
//        var alreadyConnected = false
//        for connectedNode in node1.connections {
//            if connectedNode == node2 {
//                alreadyConnected = true
//                println("already connected")
//            }
//        }
//        for connectedNode in node2.connections {
//            if connectedNode == node1 {
//                alreadyConnected = true
//                println("already connected")
//            }
//        }
//        return alreadyConnected
//    }
    
//    func removeNodeFromOdd(node:Node){
//        for i in 0...oddDegree.count {
//            if (i < oddDegree.count){
//                if oddDegree[i] == node {
//                    oddDegree.removeAtIndex(i)
//                    break
//                }
//            }
//        }
//    }
    
//    func addToOdd(node:Node){
//        if !(contains(oddDegree, node)){
//            oddDegree.append(node)
//        }
//    }
}
