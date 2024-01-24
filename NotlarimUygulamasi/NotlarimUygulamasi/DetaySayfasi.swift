//
//  DetaySayfasi.swift
//  NotlarimUygulamasi
//
//  Created by Gizemnur Özden on 24.12.2023.
//

import UIKit
import MapKit
import Firebase
import FirebaseStorage
import SDWebImage
class DetaySayfasi: UIViewController {
    
    //Anilardan sonra yönlenecek detay sayfası tanımlandı.
    @IBOutlet weak var imageViewSecilen: UIImageView!
    
    
    @IBOutlet weak var mapKitViewSecilen: MKMapView!
    @IBOutlet weak var aniBaslik: UILabel!
    
    @IBOutlet weak var tarihVeSaat: UILabel!
    
  
    
    @IBOutlet weak var alinanNotlar: UILabel!
    
    var chosenPlaceId = ""
    var secilenEnlem = Double()
    var secilenBoylam = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFromData()
        print(secilenEnlem)
        
    }
    //detaylar sayfasına veri tabanından bilgileri çeken kodlar.
    func getFromData() {
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("Anilar").whereField("aniBaslik", isEqualTo: chosenPlaceId).addSnapshotListener { (snapshot, error )in
            
            if error != nil {
                print(error?.localizedDescription)
            }else {
                if (snapshot != nil) != true && snapshot != nil {
                    
                    
                }else {
                    
                    for document in  snapshot!.documents {
                        let documentID = document.documentID
                        
                        if let aniBaslik1 = document.get("aniBaslik") as? String {
                            self.aniBaslik.text = aniBaslik1
                        }
                        if let not1  = document.get("not") as? String {
                            self.alinanNotlar.text = not1
                        }
                        if let tarihveSaat1  = document.get("date") as? String {
                            self.tarihVeSaat.text = tarihveSaat1
                        }
                        if let secilenBoylam1 = document.get("secilenBoylam") as? String {
                            if let secilenBoylamDouble = Double(secilenBoylam1) {
                                self.secilenBoylam = secilenBoylamDouble
                                print(self.secilenBoylam)
                            }
                            
                        }
                        if let secilenEnlem1 = document.get("secilenEnlem") as? String {
                            if let secilenEnlemDouble = Double(secilenEnlem1) {
                                self.secilenEnlem = secilenEnlemDouble
                                
                            }
                        }
                        if let imageData = document.get("imageUrl") as? String {
                            self.loadImageFromFirestore(photoURL: imageData)
                                    }
                        
                        //MAPS
                        //mapkit seçilen pin başlığı gelecek şekilde detaylarda gözüküyor.
                        
                        let location = CLLocationCoordinate2D(latitude: self.secilenEnlem, longitude: self.secilenBoylam)
                        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.mapKitViewSecilen.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.aniBaslik.text!
                        self.mapKitViewSecilen.addAnnotation(annotation)
                       
                        
                    }
                }
                
            }
        }
    }
    //fotoğrafı veritabanından çeken kodlar.
    func loadImageFromFirestore(photoURL: String) {
           let storage = Storage.storage()
           let storageRef = storage.reference(forURL: photoURL)
           
           // Firestore Storage'dan fotoğrafı indir
           storageRef.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
               if let error = error {
                   print("Fotoğraf yüklenirken hata oluştu: \(error.localizedDescription)")
               } else {
                   if let data = data {
                       // Fotoğrafı detay sayfasına yükle
                       self.imageViewSecilen.image = UIImage(data: data)
                   }
               }
           }
    }
}
