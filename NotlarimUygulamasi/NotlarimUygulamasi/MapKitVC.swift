//
//  MapKitVC.swift
//  NotlarimUygulamasi
//
//   Created by Gizemnur Özden & Ogün Minkara 
//

import UIKit
import MapKit
import CoreLocation
import Firebase

//Ani ekle kısmının içindeki mapKit içindir.
// lokasyon yöneticisi ile kullanıcının bulunduğu konumda haritanın açılması
// için gerekli işlemler yapıldı.
    

class MapKitVC: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate  {
   
    @IBOutlet weak var aniEkleMap: MKMapView!
    var lokasyonYönetici = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aniEkleMap.delegate = self
        lokasyonYönetici.delegate = self
        lokasyonYönetici.desiredAccuracy = kCLLocationAccuracyBest // konum tahminini en iyi şekilde yapması için.
        lokasyonYönetici.requestWhenInUseAuthorization() // uygulamayı kullanırken konum isteme için.
        lokasyonYönetici.startUpdatingLocation()
        
        let jestAlgılayıcı = UILongPressGestureRecognizer(target: self, action: #selector(pinSecici(jestAlgilayici:)))
        jestAlgılayıcı.minimumPressDuration = 2
        aniEkleMap.addGestureRecognizer(jestAlgılayıcı)
        
        
        // geri dönüş butonu eklendi.
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Kaydet", style: .plain, target: self, action: #selector(geriİkonuTiklandi))
        
        
        
       
        
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
        
    }
    
    
// pin oluşturma için gerekli kodlar yazıldı.
    @objc func pinSecici(jestAlgilayici:UILongPressGestureRecognizer) {
        
        if jestAlgilayici.state == .began {
            
            let dokunulanNokta = jestAlgilayici.location(in: self.aniEkleMap)
            let dokunulanKoordinat = self.aniEkleMap.convert(dokunulanNokta, toCoordinateFrom: self.aniEkleMap)
            
            let pin = MKPointAnnotation()
            pin.coordinate = dokunulanKoordinat
            pin.title = AniEkleModel.sharedIntance.anibaslik
            aniEkleMap.addAnnotation(pin)
            
            
//Seçilen pin koordinatlarını veritabanına aktarmak için string değerlere çevirip değişkenlere atadım.
            AniEkleModel.sharedIntance.secilenEnlem = String(dokunulanKoordinat.latitude)
            AniEkleModel.sharedIntance.secilenBoylam = String(dokunulanKoordinat.longitude)
            
          
            
// Seçilen pinin enlem ve boylam değerleri firebaseye aktarıldı aşağıda.
            
           
            
            
            
        }
    }
    
   
    /*func getDataFromFirebase() {
        
        let aniEkleModel = AniEkleModel.sharedIntance
        let firestoreDatabase = Firestore.firestore()
        
        var firestoreReference : DocumentReference? = nil
        
        let firestoreAni = [ "aniBaslik" : aniEkleModel.anibaslik, "date " : aniEkleModel.tarihvesaat,  "not": aniEkleModel.not,"kayıtBy" : Auth.auth().currentUser!.email!, "secilenEnlem" : aniEkleModel.secilenEnlem , "secilenBoylam" : aniEkleModel.secilenBoylam, ] as [String: Any]
        
        firestoreReference = firestoreDatabase.collection("Anilar").addDocument(data: firestoreAni, completion: {(error) in
            if error != nil {
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
            }else {
                //Düzenlenecek.
                //self.dismiss(animated: true)
            }
        })

        
    }
    */
    // sürekli gelen güncel konum aşağıda dizi halinde verilmiştir.
    // dizinin ilk elemanına göre enlem boylam işaretlemesi yaptım ;
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lokasyon = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        // span özelliği ile haritanın zoom derecesini seçtim.
        let span = MKCoordinateSpan(latitudeDelta: 0.1907, longitudeDelta: 0.1907)
        let region = MKCoordinateRegion(center: lokasyon, span: span)
        aniEkleMap.setRegion(region, animated: true)
        
        
    }
    
    
    
    
    
    @objc func geriİkonuTiklandi() {
        self.dismiss(animated: true)
    }
    
                                                                                        

    
}
                                                                                    
                                                                                    
