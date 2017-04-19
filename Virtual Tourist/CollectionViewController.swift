//
//  CollectionViewController.swift
//  Virtual Tourist
//
//  Created by SimranJot Singh on 16/04/17.
//  Copyright © 2017 SimranJot Singh. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class CollectionViewController: UIViewController {

    
    //MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK: Properties
    
    var pin: Pin? = nil
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths: [IndexPath]!
    
    lazy var fetchedResultsController: NSFetchedResultsController < Photos > = {
       
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "pin == %@", self.pin!)
        
        return NSFetchedResultsController(fetchRequest: request as! NSFetchRequest< Photos >, managedObjectContext:
            context, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    //MARK: LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFetchedResultsController()
        
        fetchedResultsController.delegate = self;
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(backTapped))
        
        mapView.addAnnotation(pin!)
        mapView.setRegion(MKCoordinateRegion(center: pin!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
        mapView.isUserInteractionEnabled = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchedResultsController.delegate = self
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        setCollectionFlowLayout()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        newCollectionButton.isEnabled = !editing
    }
    
    //MARK: Actions
    
    @IBAction func newCollectionsTapped(_ sender: Any) {
        
        loadNewCollection()
    }
    
    func backTapped() {
        
        let _ = navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Helper Methods
    
    func initFetchedResultsController() {
        
        do {
            
            try fetchedResultsController.performFetch()
            
        } catch { }
        
        if fetchedResultsController.fetchedObjects!.count == 0 {
            
            loadNewCollection()
        }
    }
    
    func setCollectionFlowLayout() {
        
        let items: CGFloat = view.frame.size.width > view.frame.size.height ? 5.0 : 3.0
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - ((items + 1) * space)) / items
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 8.0 - items
        layout.minimumInteritemSpacing = space
        layout.itemSize = CGSize(width: dimension, height: dimension)
        
        collectionView.collectionViewLayout = layout
    }
    
    func loadNewCollection() {
        
        newCollectionButton.isEnabled = false
        
        pin?.deletePhotos(context: context) { _ in }
        
        pin?.flickrConfig?.getPhotosForLocation(context: context) { _ in
            self.newCollectionButton.isEnabled = true
            sharedDataManager.save()
        }
    }
}


//MARK: CollectionView Delegate Extension

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionVC.CollectionViewCellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        let photo = fetchedResultsController.object(at: indexPath)
        cell.image = photo
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isEditing {
            
            context.delete(fetchedResultsController.object(at: indexPath))
            sharedDataManager.save()
        }
    }
}


//MARK: FetchedResultsController Delegates

extension CollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
            case .insert:
                insertedIndexPaths.append(newIndexPath!)
                
            case .delete:
                deletedIndexPaths.append(indexPath!)
                
            default: ()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        collectionView.performBatchUpdates({ 
            
            for indexPath in self.insertedIndexPaths {
                self.collectionView.insertItems(at: [indexPath])
            }
            
            for indexPath in self.deletedIndexPaths {
                self.collectionView.deleteItems(at: [indexPath])
            }
            
        }, completion: nil)
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        insertedIndexPaths = []
        deletedIndexPaths = []
    }
}
