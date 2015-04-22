//
//  BCCEtchASketchViewController.swift
//  EtchASketchSimulator
//
//  Created by Bri Chapman on 2/20/15.
//  Copyright (c) 2015 edu.illinois.bchapman. All rights reserved.
//

import UIKit

class BCCEtchASketchViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var leftWheel: UIImageView!
    @IBOutlet var rightWheel: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var plotPointsView: PlotPointsView!
    
    @IBOutlet weak var chosenImage: UIImageView!
    @IBOutlet weak var cannyImage: UIImageView!
    
    @IBOutlet weak var drawingView: BCCEtchASketchView!
    
    lazy var cannyHelper = ImageWrapper()
    
    var graph = Graph()
    
    var itemImage : UIImage? {
        didSet {
            chosenImage.image = itemImage
            dispatch_async(dispatch_get_main_queue(), {
                println(self.itemImage)
                var cgimage = self.itemImage?.CGImage
                var imageHeight : CGFloat = CGFloat(CGImageGetHeight(cgimage))
                var imageWidth : CGFloat = CGFloat(CGImageGetWidth(cgimage))
                
                var imageAspectRatio : CGFloat = CGFloat(imageHeight / imageWidth)
                var boxAspectRatio : CGFloat = CGFloat(self.drawingView.bounds.size.height / self.drawingView.bounds.size.width)
                
                var width : Int32
                var height : Int32
                
                if (boxAspectRatio > imageAspectRatio){
                    width = Int32((self.drawingView.bounds.size.width / imageWidth)*imageWidth)
                    height = Int32((CGFloat(width) / imageWidth)*imageHeight)
                } else {
                    height = Int32((self.drawingView.bounds.size.height / imageHeight)*imageHeight)
                    width = Int32((CGFloat(height) / imageHeight)*imageWidth)
                }
                
                width = Int32(Double(width)/4)
                height = Int32(Double(height)/4)
                
                if (width > 0 && height > 0) {
                    var greyScale : ImageWrapper = ImageWrapper.createImage(self.itemImage, width:width, height: height)
                    println("greyScale:\(greyScale)")
                    var edges : ImageWrapper = ImageWrapper.cannyEdgeExtract(greyScale, tlow: 0.3, thigh: 0.80)
                    println("edges:\(edges)")
                    self.resultingImage = ImageWrapper.makeUIImage(edges)
                    self.graph.constructGraph(self.resultingImage!, width: Int(width), height: Int(height), boxWidth: Int(self.drawingView.bounds.size.width), boxHeight: Int(self.drawingView.bounds.size.height))
                    self.drawingView.points = self.graph.orderedNodes
                    self.plotPointsView.points = self.graph.nodes
                    
                }
            })


                

//            drawingView.setNeedsDisplay()
        }
    }
    
    var resultingImage : UIImage? {
        didSet {
            cannyImage.image = resultingImage
        }
    }
    
    var leftDegree = CGFloat(0.0)
    var rightDegree = CGFloat(0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        drawingView.knobs = self
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.LandscapeRight.rawValue) | Int(UIInterfaceOrientationMask.LandscapeLeft.rawValue)
    }
    
    @IBAction func chooseImage(sender: UIBarButtonItem) {
        createPhotoActionSheet()
    }
    
    func createPhotoActionSheet() {
        var photoActionSheet = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            photoActionSheet.addAction((UIAlertAction(title: "Take New", style: UIAlertActionStyle.Default, handler: {action in
                self.takeNew()
            })))
//            photoActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {action in
//                photoActionSheet.dismissViewControllerAnimated(true, completion: nil)
//            }))
            photoActionSheet.popoverPresentationController?.barButtonItem = cameraButton
            photoActionSheet.popoverPresentationController?.sourceView = self.view
            
//            self.presentViewController(photoActionSheet, animated: true, completion: nil)
//            return
        }
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            photoActionSheet.addAction(UIAlertAction(title: "Choose from Photo Library", style: UIAlertActionStyle.Default, handler: {action in
                self.selectFromLibrary()
            }))
//            photoActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {action in
//                photoActionSheet.dismissViewControllerAnimated(true, completion: nil)
//            }))
            photoActionSheet.popoverPresentationController?.barButtonItem = cameraButton
            photoActionSheet.popoverPresentationController?.sourceView = self.view
            
//            return
        }
        self.presentViewController(photoActionSheet, animated: true, completion: nil)

        noCameraAlert()
    }
    
    
    func takeNew() {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let myAlertView = UIAlertView()
            myAlertView.title = "Error: Device has no camera or photo library."
            myAlertView.delegate = nil
            myAlertView.show()
            
        }
        
        var picker: UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    func selectFromLibrary() {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let myAlertView = UIAlertView()
            myAlertView.title = "Error: Device has no photo library"
            myAlertView.delegate = nil
            myAlertView.show()
        }
        var picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func noCameraAlert() {
        
        var noCameraAlert = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .Alert)
        noCameraAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(noCameraAlert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        itemImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        if let image = itemImage {
            println("item Image is not in fact nil")
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func rotate(duration: CFTimeInterval, image: UIImageView, degrees: Int) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        var degree = CGFloat(0.0)
        if image == leftWheel {
            degree = leftDegree
        } else if image == rightWheel {
            degree = rightDegree
        }
        rotateAnimation.fromValue = degree
        let to = CGFloat((CGFloat(degrees)/CGFloat(360))*(CGFloat(M_PI * 2.0))) + CGFloat(degree)
        rotateAnimation.toValue = to
        if image == leftWheel {
            leftDegree = to
        } else if image == rightWheel {
            rightDegree = to
        }
        
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = nil {
            rotateAnimation.delegate = delegate
        }
        image.layer.addAnimation(rotateAnimation, forKey: nil)
    }
    
    func rotateKnobs(fromPoint: CGPoint, toPoint: CGPoint, duration: NSTimeInterval){
        let conversionFactor = 2.0
        
        //left knob controls x
        //positive degrees move line to the right
        //negative degrees move line to the left
        let horizontalComponent = toPoint.x - fromPoint.x
        let horizontalDegrees = conversionFactor * Double(horizontalComponent)
        rotate(duration, image: leftWheel, degrees: Int(horizontalDegrees))
        
        //right knob controls y
        //positive degrees move line down
        //negative degrees move line up
        let verticalComponent = fromPoint.y - toPoint.y
        let verticalDegrees = conversionFactor * Double(verticalComponent)
        rotate(duration, image: rightWheel, degrees: Int(verticalDegrees))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
