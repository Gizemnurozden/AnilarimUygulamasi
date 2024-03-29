//
//  Hesap.swift
//  NotlarimUygulamasi
//
//   Created by Gizemnur Özden & Ogün Minkara 
//

import UIKit
import Firebase
import FirebaseAuth

class Hesap: UIViewController {

    @IBOutlet weak var baslikLabel: UILabel!
    
    
    @IBOutlet weak var emailText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
//veritabanından giriş yapan kullanıcının emailini çekiyor.
        
        if let user = Auth.auth().currentUser {
            if let email = user.email {
                emailText.text = email
                print("Kullanıcı email: \(email)")
            } else {
                print("Kullanıcının email bilgisi bulunamadı.")
            }
        } else {
            print("Kullanıcı oturum açmamış.")
        }

    }
    
//Hesaptan çıkış yapmak için çıkış butonu
    @IBAction func buttonCikis(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        }catch {
            print("error")
        }
        
        
    }
 //şifremi unuttuma tıklayınca şifre güncelleme sayfasına yönlendiriyor.
    
    @IBAction func sifremiUnuttumTiklandi(_ sender: Any) {
        performSegue(withIdentifier: "hesapToSifremiUnuttum", sender: nil
        )
        
    }
    
}
