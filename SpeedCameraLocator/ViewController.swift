//
//  ViewController.swift
//  SpeedCameraLocator
//
//  Created by Raul on 4/16/15.
//  Copyright (c) 2015 rauluranga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var isTracking: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var camera = GMSCameraPosition.cameraWithLatitude(25.433353,longitude:-101.002808, zoom:13)
        
        mapView.camera = camera;
        //var mapView = GMSMapView.mapWithFrame(CGRectZero, camera:camera)
        
        mapView.myLocationEnabled = true;
        
        var marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Hello World"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        
    }
    
    
    @IBAction func toogleTracking(sender: UIButton) {
        isTracking = !isTracking;
        if isTracking {
            sender.setTitle("Stop Tracking", forState: UIControlState.Normal);
        } else {
            sender.setTitle("Start Tracking", forState: UIControlState.Normal);
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

