//
//  Notlarim.swift
//  NotlarimUygulamasi
//
//   Created by Gizemnur Özden & Ogün Minkara 
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class Anilarim: UIViewController, UITableViewDelegate, UITableViewDataSource, FavoriButonDelegate {
    
  
    

    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
   
    var aniBaslikArray = [String()]
    var kullaniciFotoArray = [String()]
    var notArray = [String()]
    var tarihArray = [String()]
    var secilenAniId = ""
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
       
        
    }
    //favori butonu tıklanınca perform Segue yapacak
    func favoriButonTiklandi(forCell cell: UITableViewCell) {
        performSegue(withIdentifier: "toFavoriVC", sender: nil)
    }
   
    
    //DATABASE
    
    func getDataFromFirestore(){
        
        
        let fireStoreDatabase = Firestore.firestore()
        
        //Veritabanında kullanıcı kontrol etme
        guard let currentUser = Auth.auth().currentUser else {
            // Kullanıcı oturum açmamışsa, işlemi iptal et
            return
        }
        //emaile göre kullanıcı kontrol etme
        let userEmail = currentUser.email
        
        if let userEmail = userEmail {
            fireStoreDatabase.collection("Anilar").whereField("kayıtBy", isEqualTo: userEmail).order(by: "date", descending: true).addSnapshotListener { (snapshot, error )in
            
            if error != nil {
                print(error?.localizedDescription)
            }else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.aniBaslikArray.removeAll(keepingCapacity: false)
                    self.kullaniciFotoArray.removeAll(keepingCapacity: false)
                    self.tarihArray.removeAll(keepingCapacity: false)
                    self.notArray.removeAll(keepingCapacity: false)
                    
                    
                    
                    
                    for document in  snapshot!.documents {
                        let documentID = document.documentID
                        
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
                       
                    }
                    
                    self.tableView.reloadData()
                }
                
            }
        }
            
        }
    }
    //tıklandığında detay sayfasına geçiş kodları
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destinationVC = segue.destination as! DetaySayfasi
            destinationVC.chosenPlaceId = secilenAniId
        }
    }
    //tıkladnığında detay sayfasına geçiş kodları
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilenAniId = aniBaslikArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailVC", sender: nil)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aniBaslikArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let hucre = tableView.dequeueReusableCell(withIdentifier: "anilarHucre", for: indexPath) as! AnilarimHucre
       
        
        
        hucre.aniBaslikLabel.text = aniBaslikArray[indexPath.row]
        hucre.imageViewSecilen.sd_setImage(with: URL(string: self.kullaniciFotoArray[indexPath.row]))
        hucre.tarihVeSaatLabel.text = tarihArray[indexPath.row]
       
        return hucre
    }
    //VERİTABANINDAN VE ARAYÜZDEN SİLME İŞLEMLERİ YAZILDI.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let silAction = UIContextualAction(style: .destructive, title: "Sil") { contextualAction, view, bool in
                let selectedAniBaslik = self.aniBaslikArray[indexPath.row]
                let alert = UIAlertController(title: "Silme işlemi", message: "Silinsin mi ?", preferredStyle: .alert)
                           let iptalAction = UIAlertAction(title: "İptal", style: .cancel )
                           alert.addAction(iptalAction)
                let evetAction = UIAlertAction(title: "Evet", style: .destructive) {_ in 
                    
                    // Uygulama içindeki verileri güncelle
                    self.aniBaslikArray.remove(at: indexPath.row)
                    self.kullaniciFotoArray.remove(at: indexPath.row)
                    self.tarihArray.remove(at: indexPath.row)
                    self.notArray.remove(at: indexPath.row)

                    // Firestore'dan veriyi sil
                    self.deleteDataFromFirestore(aniBaslik: selectedAniBaslik)

                    // TableView'yi güncelle
                    tableView.deleteRows(at: [indexPath], with: .automatic)

                    
                }
                
                           alert.addAction(evetAction)
                           
                           self.present(alert, animated: true)
               
            }
            return UISwipeActionsConfiguration(actions: [silAction])
        }
    //FİREBASEDEN SİLME KODLARI
    func deleteDataFromFirestore(aniBaslik: String) {
            let fireStoreDatabase = Firestore.firestore()
            
            fireStoreDatabase.collection("Anilar").whereField("aniBaslik", isEqualTo: aniBaslik).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error.localizedDescription)")
                } else {
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        
                        // Firestore'dan belgeyi sil
                        fireStoreDatabase.collection("Anilar").document(documentID).delete { error in
                            if let error = error {
                                print("Error deleting document: \(error.localizedDescription)")
                            } else {
                                print("Document successfully deleted!")
                            }
                        }
                    }
                }
            }
        }
}
//SEARCH BAR kısmı

extension Anilarim : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            getDataFromFirestore()
        }else {
            aniBaslikArray = aniBaslikArray.filter { $0.lowercased().contains(searchText.lowercased()) }
            tableView.reloadData()
        }
            }
    
    
    
}


