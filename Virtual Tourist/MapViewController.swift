//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 12/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        navigationItem.rightBarButtonItem = editButtonItem
        initialSetup()
    }
    
    private func initialSetup() {
        
        addAnnotations()
        setMapRegion()
        addLongPressGesture()
    }
}


//MARK: MapView Delegate Extension

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pin = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.MapViewController.PinReuseIdentifier) as? MKPinAnnotationView ??
                                            MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.MapViewController.PinReuseIdentifier)
        
        pin.animatesDrop = true
        pin.isDraggable = true
        
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        if ((!isEditing) && (oldState == .ending)) {
            
            let pin = view.annotation as! Pin
            
            pin.deletePhotos(context: context, handler: { (errorString) in
                
                if let errorString = errorString {
                    
                    print(errorString)
                }
                else {
                    
                    sharedDataManager.save()
                }
            })
            
            getPhotosForPin(pin)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let pin = view.annotation as! Pin
        isEditing ? showActionSheetForPin(pin) : showDetails(pin)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let _ = MapRegion(region: mapView.region, context: context)
        sharedDataManager.save()
    }
}


//MARK: Helper Methods Extension

extension MapViewController {
    
    
    //MARK: Initial Setup Helpers
    
    fileprivate func addLongPressGesture() {
        
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(dropPinOnMap(sender:))))
    }
    
    private func fetchPinsFromDB(handler: @escaping ([Pin]) -> Void) {
        
        var pins = [Pin]()
        
        context.perform { 
            
            do {
                
                pins =  try context.fetch(Pin.fetchRequest()) as! [Pin]
                
            } catch {
                
                print("Oops... we could not load pins")
            }
            
            handler(pins)
        }
    }
    
    fileprivate func addAnnotations() {
        
        unowned let weakSelf = self
        
        fetchPinsFromDB { (pins) in
            
            weakSelf.mapView.addAnnotations(pins)
        }
    }
    
    private func fetchMapRegion(handler: @escaping ([MapRegion]) -> Void) {
        
        var mapRegion = [MapRegion]()
        
        context.perform { 
            
            do {
                
                mapRegion = try context.fetch(MapRegion.fetchRequest()) as! [MapRegion]
                
            } catch {
                
                print("Map Region Couldn't be Loaded")
            }
            
            handler(mapRegion)
        }
    }
    
    fileprivate func setMapRegion() {
        
        unowned let weakSelf = self
        
        fetchMapRegion { (mapRegion) in
            
            if mapRegion.count > 0 {
                
                weakSelf.mapView.setRegion((mapRegion.last?.region)!, animated: true)
            }
        }
    }
}


//MARK: Action Helpers Extension

extension MapViewController {
    
    @objc fileprivate func dropPinOnMap(sender: UIGestureRecognizer) {
        
        if sender.state == .began {
            
            let coordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            let pin  = Pin(latitude: coordinate.latitude, longitude: coordinate.longitude, context: context)
            
            getPhotosForPin(pin)
            
            mapView.addAnnotation(pin)
            sharedDataManager.save()
        }
    }
    
    fileprivate func getPhotosForPin(_ pin: Pin) {
        
        pin.flickrConfig?.getPhotosForLocation(context: context, handler: { (errorString) in
            
            if let errorString = errorString {
                
                print(errorString)
            }
            else {
                
                sharedDataManager.save()
            }
        })
    }
    
    fileprivate func deletePin(_ pin: Pin) {
        
        context.delete(pin)
        mapView.removeAnnotation(pin)
        sharedDataManager.save()
    }
    
    fileprivate func showDetails(_ pin: Pin) {
        
        //TODO: Push to Detail View
    }
    
    fileprivate func showActionSheetForPin(_ pin: Pin) {
        
        let alert = UIAlertController.init(title: "Remove Location?", message: nil, preferredStyle: .actionSheet)
        
        let actionYes =  UIAlertAction(title: "Yes!", style: .destructive) { _ in
            
            self.deletePin(pin)
        }
        alert.addAction(actionYes)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
}

