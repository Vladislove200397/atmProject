//
//  ViewController.swift
//  ATMinfo
//
//  Created by Vlad Kulakovsky  on 12.01.23.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils

class ViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var atmArr: [AtmModel] = []
    var markers: [GMSMarker] = []
    var clusterManager: GMUClusterManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getAtms(city: "Минск")
        self.view.backgroundColor = .blue
    }
    
    private func setUpClusterManager() {
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let render = GMUDefaultClusterRenderer(mapView: self.mapView, clusterIconGenerator: iconGenerator)
        
        clusterManager = GMUClusterManager(map: self.mapView, algorithm: algorithm, renderer: render)
        clusterManager.add(markers)
        mapView.clear()
        clusterManager.cluster()
    }
    
    private func getAtms(city: String) {
        self.spinner.startAnimating()
        AtmProvider().getCurrency(city: city) { atmsArr in
            self.atmArr = atmsArr
            self.drawClusteringMarkers()
            
            self.spinner.stopAnimating()
        } failure: { error in
            print(error)
        }
    }
    
    private func cameraZoomOnTap(coordinate: CLLocationCoordinate2D) {
        let camera =
        GMSCameraPosition(latitude: coordinate.latitude,
                          longitude: coordinate.longitude,
                          zoom: 18)
        mapView.animate(to: camera)
    }
    
    private func drawClusteringMarkers() {
        atmArr.enumerated().forEach { index, atm in
            let marker =
            GMSMarker(position: CLLocationCoordinate2D(
                latitude: Double(atm.latitude) ?? 0.0,
                longitude: Double(atm.longitude) ?? 0.0))
            marker.userData = atm
            
            if atm.atmError == "да" {
                marker.icon = GMSMarker.markerImage(with: UIColor.red)
            } else {
                marker.icon = GMSMarker.markerImage(with: UIColor.green)
            }
            marker.map = mapView
            markers.append(marker)
            self.setUpClusterManager()
            clusterManager.setMapDelegate(self)
        }
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.animate(toLocation: marker.position)
        
        mapView.selectedMarker = marker
        
        cameraZoomOnTap(coordinate: CLLocationCoordinate2D(
            latitude: marker.position.latitude,
            longitude: marker.position.longitude))
        if marker.userData is GMUCluster {
            mapView.animate(toZoom: mapView.camera.zoom + 1)
            return true
        } else {
            if let atm = marker.userData as? AtmModel {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let infoVC = storyboard.instantiateViewController(withIdentifier: String(describing: AtmInfoController.self)) as? AtmInfoController else { return false }
                infoVC.set(atm: atm)
                present(infoVC, animated: true)
            }
            return true
        }
    }
}
