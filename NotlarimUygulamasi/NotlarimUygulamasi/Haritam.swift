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

class Haritam: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapKit: MKMapView!

    var lokasyonYönetici = CLLocationManager()
    var db: Firestore!
    var locations = [(latitude: Double, longitude: Double, title: String)]()

    override func viewDidLoad() {
        super.viewDidLoad()
// kullanıcıdan konumunu aldığımız kodlar mapkitVC den alındı.
        lokasyonYönetici.delegate = self
        lokasyonYönetici.desiredAccuracy = kCLLocationAccuracyBest
        lokasyonYönetici.requestWhenInUseAuthorization()
        lokasyonYönetici.startUpdatingLocation()

        db = Firestore.firestore()

        firebaseLokasyonlari()
        addAnnotationsToMap()

        mapKit.delegate = self
    }

// veritabanından konumları enlem ve boylam olarak çektiğimiz kod.
    func firebaseLokasyonlari() {
        db.collection("Anilar").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Firestore verileri alınamadı: \(error.localizedDescription)")
            } else {
                for document in querySnapshot!.documents {
                    if let latitudeString = document["secilenEnlem"] as? String,
                        let longitudeString = document["secilenBoylam"] as? String,
                        let latitude = Double(latitudeString),
                        let longitude = Double(longitudeString),
                        let title = document["aniBaslik"] as? String {
                            let location = (latitude: latitude, longitude: longitude, title: title)
                            self.locations.append(location)
                    }
                }
                self.addAnnotationsToMap()
            }
        }
    }
// locations adlı bi dizi oluşturup dizi içinde locationlar için döngü oluşturuyor ve alınan her değeri coordinate atıyor bu kod chatgpt destekli
    func addAnnotationsToMap() {
        for location in locations {
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location.title
            mapKit.addAnnotation(annotation)
        }
    }

// haritanın güncel gelen konum dizisinin ilk elemanlarına göre yakınlaştırma yapmasını sağlayan fonksiyon (mapKitVC kısmından alıntılandı.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lokasyon = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
// yakınlaştırma derecesini ayarlayan sayılar şimdilik 0.6 olarak düzenledim.
        let span = MKCoordinateSpan(latitudeDelta: 0.6, longitudeDelta: 0.6)
        let region = MKCoordinateRegion(center: lokasyon, span: span)
        mapKit.setRegion(region, animated: true)
    }

// mapView fonksiyonu seçilen pinin koordinatlarını alan , uyarı mesajı gösteren ve yönlendiren fonksiyon seçilen pin bir MKPointAnnotation ise yönlendirmeye başlıyor.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MKPointAnnotation {
            let destinationLocation = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            haritalarAcmaUyarısı(destinationLocation: destinationLocation)
        }
    }

    // apple haritalar açılmadan önce bir uyarı veren alertAction butonu
    func haritalarAcmaUyarısı(destinationLocation: CLLocationCoordinate2D) {
        let uyari = UIAlertController(title: "Apple Haritalarda Göster", message: "Seçilen konuma haritadan yol tarifi ister misiniz ? ", preferredStyle: .alert)
        let iptal = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        let devam = UIAlertAction(title: "Göster", style: .default) { (_) in
            self.haritalariAc(hedefKonum: destinationLocation)
        }

       uyari.addAction(iptal)
        uyari.addAction(devam)

        present(uyari, animated: true, completion: nil)
    }
    
    
// apple haritalar uygulamasına yönlendirme fonksiyonu
    func haritalariAc(hedefKonum: CLLocationCoordinate2D) {
        let konumHaritalar = MKMapItem(placemark: MKPlacemark(coordinate: hedefKonum, addressDictionary: nil))
        konumHaritalar.name = "Hedef Konum"
        konumHaritalar.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
