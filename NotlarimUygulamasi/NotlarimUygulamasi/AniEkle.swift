//
//  AniEkle.swift
//  NotlarimUygulamasi
//
//   Created by Gizemnur Özden & Ogün Minkara 
//

import UIKit
import MapKit
import Firebase
import FirebaseStorage

class AniEkle: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  
    @IBOutlet weak var imageViewFotoSec: UIImageView!
    
    @IBOutlet weak var aniBaslikText: UITextField!
    @IBOutlet weak var tarihSaatText: UITextField!
    @IBOutlet weak var notTextView: UITextView!
    @IBOutlet weak var mapKitView: MKMapView!

    
    var datePicker:UIDatePicker?
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        
//görünüm kodları
        
        let app = UINavigationBarAppearance()
        app.backgroundColor = UIColor.tertiarySystemBackground
        app.titleTextAttributes = [.foregroundColor: UIColor.systemIndigo]
        app.largeTitleTextAttributes = [.foregroundColor: UIColor.systemGray]
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.standardAppearance = app
        navigationController?.navigationBar.compactAppearance = app
        navigationController?.navigationBar.scrollEdgeAppearance = app
        
        
        
        
        
        
//Fotoğraf seçin üstüne basılınca fotoğraf seçme yazıldı.
//Albüme gidiş yazıldı.
        imageViewFotoSec.isUserInteractionEnabled = true
        let fotografSec = UITapGestureRecognizer(target: self, action: #selector(fotografSec))
        imageViewFotoSec.addGestureRecognizer(fotografSec)
        
//NAvigation bar'a Save kısmı eklendi.
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Kaydet", style: .plain, target: self, action: #selector(saveButtonTiklandi))
//navigatiın bar'a back buttonu eklendi
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Geri", style: .plain, target: self, action: #selector(backButtonTiklandi))
//mapkite tıklanınca geçiş yapıldı.
        mapKitView.isUserInteractionEnabled = true
        let mapKitSec = UITapGestureRecognizer(target: self, action: #selector(mapKitTiklandi))
        mapKitView.addGestureRecognizer(mapKitSec)
        
        
//Tarih ve Saat seçme özellikleri eklendi.
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        tarihSaatText.inputView = datePicker
        
        if #available(iOS 13.4, *) {
            datePicker?.preferredDatePickerStyle = .wheels
        }
        
        
        let dokunmaAlgilama = UITapGestureRecognizer(target: self, action: #selector(dokunmaAlgilamaMetod))
        view.addGestureRecognizer(dokunmaAlgilama)
        
        datePicker?.addTarget(self, action: #selector(tarihVeSaatGoster(uiDatePicker:)), for: .valueChanged)
        
    }
    
    @objc func dokunmaAlgilamaMetod() {
        view.endEditing(true)
    }
    @objc func tarihVeSaatGoster (uiDatePicker: UIDatePicker){
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyyy HH:mm"
        let alinanTarih = format.string(from: uiDatePicker.date)
        tarihSaatText.text = alinanTarih
    }
    

    @objc func fotografSec() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageViewFotoSec.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
        
    }
//kaydetme kodları
    @objc func saveButtonTiklandi () {
        
        let storage = Storage.storage()
        let storageReferance = storage.reference()
         
//Storage içinde açtığım medya dosyası
        let mediaFolder = storageReferance.child("media")
        
        if let data = imageViewFotoSec.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            imageReferance.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                    
                }else {
                    
                    imageReferance.downloadURL{ (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
//DATABASE
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestoreAni = [ "imageUrl" : imageUrl!, "kayıtBy" : Auth.auth().currentUser!.email!, "aniBaslik": self.aniBaslikText.text!, "date" : self.tarihSaatText.text!, "not": self.notTextView.text!,"secilenEnlem": AniEkleModel.sharedIntance.secilenEnlem,"secilenBoylam" : AniEkleModel.sharedIntance.secilenBoylam , "likes" : false ] as [String: Any]
                            
                            firestoreReference = firestoreDatabase.collection("Anilar").addDocument(data: firestoreAni, completion: {(error) in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                                }else {
                                    
                                }
                            })
                        }
                    }
                }
            }
        }
        self.dismiss(animated: true)
    }
    
    @objc func backButtonTiklandi () {
        self.dismiss(animated: true, completion: nil)
    }
//mapkit tıklanınca yapılacak olan işlemler eklendi.
    @objc func mapKitTiklandi (){
        
        if aniBaslikText.text != "" {
            if let secilenFoto = imageViewFotoSec.image {
                
                let aniEkleModel = AniEkleModel.sharedIntance
                aniEkleModel.anibaslik = aniBaslikText.text!
                aniEkleModel.tarihvesaat = tarihSaatText.text!
                aniEkleModel.not = notTextView.text!
                aniEkleModel.secilenImage = secilenFoto
                
            }
            performSegue(withIdentifier: "toMapKitVC", sender: nil)
            
        } else {
            let alert = UIAlertController(title: "Error!", message: "Anı Başlık veya Fotoğraf eksik", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }
        
        
      
       
    }
    
   
}
