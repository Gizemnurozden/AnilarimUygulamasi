//
//  ViewController.swift
//  NotlarimUygulamasi
//
//   Created by Gizemnur Özden & Ogün Minkara 
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
// butonlar eklendi

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var sifreText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
//Kullanıcı adıyla giriş yaptıktan sonra uygulama her açıldığında tekrar giriş yapmamak için uygulamanın bir kere girince hatırlamasını sağlayan kod bloğu lazım onun için sceneDelegate'a ekleme yapıyorum.Oraya bak.
     
        
    }
    
//giriş yap butonu işlemleri
    
    @IBAction func buttonGirisYap(_ sender: Any) {
       
        if emailText.text != "" && sifreText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: sifreText.text!) {(authdata, error) in
                if error != nil {
                   self.makeAlert(titleGiris: "Error!", messageGiris: error!.localizedDescription)

                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
            
        }else {
            makeAlert(titleGiris: "Error!", messageGiris: "Kullanıcı adı ve Şifre giriniz.")
        }
        
        
        
    }
    
//kayıt ol butonu işlemleri
    
    @IBAction func buttonKayitOl(_ sender: Any) {
         //kullanıcının boş bırakma ihtimali olduğu için if kullanıyoruz
        //Auth kullanarak veritabanında kullanıcı oluşturuyorum.Ve yazılanları .text dieyerk çekiyorum.
        self.performSegue(withIdentifier: "girisToKayit", sender: nil)
        
    }
//tüm else veya if lerin altına tek tek alert oluşturmak yerine bir alert fonksiyonu oluşturdum ve if ve elselein altında direkt bu fonksiyonu çağırıyorum. fonksiyonma başlık ve mesaj zorunlulğu verdim.
    func makeAlert(titleGiris:String, messageGiris:String) {
        let alert = UIAlertController(title: titleGiris, message: messageGiris, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "TAMAM", style: .cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
    @IBAction func sifremiUnuttumButton(_ sender: Any) {
        performSegue(withIdentifier: "toSifremiUnuttum", sender: nil)
    }
    
}

