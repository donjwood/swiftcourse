//
//  MKGPX.swift
//  Trax
//
//  Created by Donald Wood on 6/23/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import MapKit

class EditableWaypoint: GPX.Waypoint
{
    override var coordinate: CLLocationCoordinate2D {
        get { return super.coordinate }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
    override var thumbnailURL: NSURL? {return imageURL}
    override var imageURL: NSURL? {return links.first?.url}

}

extension GPX.Waypoint: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? { return name }
    
    var subtitle: String? {return info}
    
    var thumbnailURL: NSURL? {return getImageURLOfType("thumbnail")}
    var imageURL: NSURL? {return getImageURLOfType("large")}
    
    private func getImageURLOfType(type: String) -> NSURL? {
        for link in links {
            if link.type == type {
                return link.url
            }
        }
        return nil
    }
}
