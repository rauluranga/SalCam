//
//  ViewController.swift
//  SpeedCameraLocator
//
//  Created by Raul on 4/16/15.
//  Copyright (c) 2015 rauluranga. All rights reserved.
//

//http://blog.mediarain.com/2012/11/google-maps-finding-a-latlng-at-a-given-distance-on-a-path/
//http://stackoverflow.com/questions/14664685/google-maps-circle-to-polyline-coordinate-array
//http://jomacinc.com/map-radius/
//https://github.com/mattt/Surge
//https://github.com/ankurp/Dollar.swift

import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tracking_btn: UIButton!
    
    var isTracking: Bool = false;
    var userDidTap: Bool = false;
    
    let locationManager = CLLocationManager()
    
    let cameras = [
        CLLocationCoordinate2DMake(25.412071, -101.016570),
        CLLocationCoordinate2DMake(25.407954, -101.019309)]
    
    var camera_regions:[GMSPolygon] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var camera = GMSCameraPosition.cameraWithLatitude(25.433353,longitude:-101.002808, zoom:17)
        mapView.camera = camera;
        
        let labelHeight = tracking_btn.intrinsicContentSize().height
        mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
        
        for cam_position in cameras {
            
            var polygon = GMSCirclePolygon(radius: 100,location:cam_position)
            polygon.fillColor = UIColor(red:0.25, green:0, blue:0, alpha:0.05)
            polygon.strokeColor = UIColor.blackColor()
            polygon.strokeWidth = 2
            polygon.map = mapView
            
            camera_regions.append(polygon)
            
            var marker = GMSMarker()
            marker.position = cam_position
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.icon = UIImage(named:"camera_pin");
            marker.map = mapView
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    //MARK: toogle tracking
    
    @IBAction func toogleTracking(sender: UIButton) {
        isTracking = !isTracking;
        userDidTap = true;
        if isTracking {
            println("Tracking User position.....");
            sender.setTitle("Stop Tracking", forState: UIControlState.Normal);
            locationManager.startUpdatingLocation();
        } else {
            println("Tracking stopped");
            sender.setTitle("Start Tracking", forState: UIControlState.Normal);
            locationManager.stopUpdatingLocation();
        }
        
    }
    
    //MARK: CLLocation Manager
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedAlways {
            locationManager.startUpdatingLocation();
            mapView.myLocationEnabled = true;
            mapView.settings.myLocationButton = true;
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        if let location = locations.first as? CLLocation {
            
            mapView.animateWithCameraUpdate(GMSCameraUpdate.setTarget(location.coordinate))
            
            if !userDidTap {
                locationManager.stopUpdatingLocation( );
            }
            
            var inDaZone:Bool = camera_regions.any { element in
                return GMSGeometryContainsLocation(location.coordinate, element.path, false)
            }
            
            if inDaZone {
                SoundManager.sharedInstance.playAlarm()
            } else {
                SoundManager.sharedInstance.stopAlarm()
            }
        }
    }

    //MARK: Memory handler
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }

}



