//
//  GMSPolygon.swift
//
//  Created by Raul on 4/21/15.
//  Copyright (c) 2015 rauluranga. All rights reserved.
//

import Darwin

class GMSCirclePolygon: GMSPolygon {

    init(radius:Int, position:CLLocationCoordinate2D, detail:Int) {
        super.init()
        self.path = drawCirclePath(position, radius: radius, detail: detail)
    }

    convenience init (radius:Int, position:CLLocationCoordinate2D) {
        self.init(radius: radius, position: position, detail: 8)
    }

    private func drawCirclePath(point:CLLocationCoordinate2D, radius:Int, detail:Int) -> GMSMutablePath {

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

}
