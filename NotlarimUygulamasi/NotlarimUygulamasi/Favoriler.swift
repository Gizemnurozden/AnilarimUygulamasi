//
//  Favoriler.swift
//  NotlarimUygulamasi
//
//  Created by Gizemnur Özden & Ogün Minkara
//

import UIKit
import Firebase
import SDWebImage
import FirebaseFirestore
import FirebaseAuth


class Favoriler: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var aniBaslikArray = [String()]
    var kullaniciFotoArray = [String()]
    var notArray = [String()]
    var tarihArray = [String()]
    var likesArray = [Bool()]
    var documentIdArray = [String()]
    var documentID: String?
    var secilenAniId = ""
    
    @IBOutlet weak var favorilerTableView: UITableView!
  
  

       override func viewDidLoad() {
           super.viewDidLoad()

          favorilerTableView.delegate = self
          favorilerTableView.dataSource = self

           // Firestore'dan favori anıları çek
           getDataFromFirestore()
       }
    
    
//datadan like true olanları çekme kodları
    func getDataFromFirestore(){
        
        
        let fireStoreDatabase = Firestore.firestore()
     
        
       
            fireStoreDatabase.collection("Anilar").whereField("likes", isEqualTo: true).order(by: "date", descending: true).addSnapshotListener { (snapshot, error )in
            
            if error != nil {
                print(error?.localizedDescription)
            }else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.aniBaslikArray.removeAll(keepingCapacity: false)
                    self.kullaniciFotoArray.removeAll(keepingCapacity: false)
                    self.tarihArray.removeAll(keepingCapacity: false)
                    self.notArray.removeAll(keepingCapacity: false)
                    self.likesArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    
                    
                    for document in  snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let aniBaslik = document.get("aniBaslik") as? String {
                            self.aniBaslikArray.append(aniBaslik)
                        }
                        
                        if let not = document.get("not") as? String {
                            self.notArray.append(not)
                        }
                        
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.kullaniciFotoArray.append(imageUrl)
                        }
                        if let date = document.get("date") as? String {
                            self.tarihArray.append(date)
                        }
                        if let likes = document.get("likes") as? Bool  {
                            self.likesArray.append(likes)
                        }
                       
                    }
                    
                    self.favorilerTableView.reloadData()
                }
                
            }
        }
            
        
        
        
    }
    
//tableview kodları
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likesArray.count
       }
    

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "favorilerHucre", for: indexPath) as! FavorilerHucre
           
           cell.anibaslikFavori.text = aniBaslikArray[indexPath.row]
           cell.imageViewSecilen.sd_setImage(with: URL(string: self.kullaniciFotoArray[indexPath.row]))
           cell.tarihVeSaatFavori.text = tarihArray[indexPath.row]
           
           
           return cell
       }
   
    
   
    

    //tıklandığında detay sayfasına geçiş kodları
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favorilerToDetay" {
            let destinationVC = segue.destination as! DetaySayfasi
            destinationVC.chosenPlaceId = secilenAniId
        }
    }
    //tıkladnığında detay sayfasına geçiş kodları
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilenAniId = aniBaslikArray[indexPath.row]
        self.performSegue(withIdentifier: "favorilerToDetay", sender: nil)
    }
   
    

}

