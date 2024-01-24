//
//  SifremiUnuttum.swift
//  NotlarimUygulamasi
//
//  Created by Gizemnur Özden on 22.01.2024.
//

import UIKit
import FirebaseAuth
import Firebase

class SifremiUnuttum: UIViewController {
    
    
    @IBOutlet weak var emailDogrulamaText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func resetPassword(for email: String) {
        
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("Şifre sıfırlama başarısız: \(error.localizedDescription)")
            } else {
                
                let alert = UIAlertController(title: "Bağlantı Gönderildi !", message: "E-mail adresiniz sistemde kayıtlı ise mailinizi kontrol ediniz.Mail gelmediyse Kayıt Ol seçeneğinden yeni hesap oluşturabilirsiniz.", preferredStyle: UIAlertController.Style.alert)
                let tamamButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel){_ in
                    self.performSegue(withIdentifier: "sifreToGiris", sender: nil)
                    return
                }
               
                    alert.addAction(tamamButton)
                    self.present(alert, animated: true)
                }
            }
        }
        
        
        
        @IBAction func sifreYenileButton(_ sender: Any) {
            
            let userEmail = emailDogrulamaText.text!
            resetPassword(for: userEmail)
        }
        
        
        
        
        
    }

