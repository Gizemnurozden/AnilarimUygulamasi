//
//  Haritam.swift
//  NotlarimUygulamasi
//
//  Created by Gizemnur Özden & Ogün Minkara 
//

import UIKit
import MapKit
import Firebase
import FirebaseFirestore
import FirebaseAuth


class Haritam: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapKit: MKMapView!
    
    
    var lokasyonYönetici = CLLocationManager()
    var db: Firestore!
    var locations = [(latitude: Double, longitude: Double, title: String)]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        lokasyonYönetici.delegate = self
                lokasyonYönetici.desiredAccuracy = kCLLocationAccuracyBest // konum tahminini en iyi şekilde yapması için.
                lokasyonYönetici.requestWhenInUseAuthorization() // uygulamayı kullanırken konum isteme için.
                lokasyonYönetici.startUpdatingLocation()
                // Firestore konfigürasyonu
                       db = Firestore.firestore()

                       // Harita ayarları
                       let initialLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
                       let regionRadius: CLLocationDistance = 10000
                       let coordinateRegion = MKCoordinateRegion(center: initialLocation, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
                       mapKit.setRegion(coordinateRegion, animated: true)

                       // Firestore verilerini çekme
                       fetchLocationsFromFirestore()
                       addAnnotationsToMap()
        
        
        
    }
    
    
    func fetchLocationsFromFirestore() {
            db.collection("Anilar").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Firestore verileri alınamadı: \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                if let latitudeString = document["secilenEnlem"] as? String,
                let longitudeString = document["secilenBoylam"] as? String,
                let latitude = Double(latitudeString),
                let longitude = Double(longitudeString),
                let title = document["aniBaslik"] as? String { // "baslik" yerine kendi başlık alanınızı kullanın
                let location = (latitude: latitude, longitude: longitude, title: title)
                self.locations.append(location)
                                          }
                                      }
                self.addAnnotationsToMap()
                                  }
                              }
                          }
    
    func addAnnotationsToMap() {
            for location in locations {
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location.title
            mapKit.addAnnotation(annotation)
                              }
            }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let lokasyon = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            // span özelliği ile haritanın zoom derecesini seçtim.
            let span = MKCoordinateSpan(latitudeDelta: 0.9, longitudeDelta: 0.9)
            let region = MKCoordinateRegion( center:lokasyon , span: span)
            mapKit.setRegion(region, animated: true)
            
            
        }
 
}
