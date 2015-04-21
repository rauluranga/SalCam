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
import Darwin

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
            
            var polygon = GMSPolygon(path: drawCirclePath(cam_position, radius: 100, detail: 8))
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
    
    func drawCirclePath(point:CLLocationCoordinate2D, radius:Int, detail:Int) -> GMSMutablePath {
        
        let R    = 6371009.0; // earh radius in meters
        let pi   = M_PI;
        
        let Lat  = (point.latitude * pi) / 180;
        let Lng  = (point.longitude * pi) / 180;
        let d    = Double(radius) / R;
        
        let path = GMSMutablePath()
        
        for(var i = 0; i <= 360; i += detail) {
            
            var brng = Double(i) * pi / 180.0;
            var pLat = asin(sin(Lat)*cos(d) + cos(Lat)*sin(d)*cos(brng));
            var pLng = ((Lng + atan2(sin(brng)*sin(d)*cos(Lat), cos(d)-sin(Lat)*sin(pLat))) * 180) / pi;
            pLat = (pLat * 180.0)/pi;
            
            path.addCoordinate(CLLocationCoordinate2DMake(pLat, pLng))
        }
        return path
    }

    //MARK: Memory handler
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }

}



