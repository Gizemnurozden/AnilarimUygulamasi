//
//  kayit.swift
//  NotlarimUygulamasi
//
//  Created by Ogün Minkara on 21.01.2024.
//

import UIKit
import Firebase
import FirebaseAuth

class kayit: UIViewController {
    @IBOutlet weak var mailText: UITextField!
    
    @IBOutlet weak var sifreText: UITextField!
    
    @IBOutlet weak var sifreTekrarText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Giriş Ekranına Dön ", style: .plain, target: self, action: #selector(backButton))
        
        
    }
    
    
    
    @IBAction func kayitOlButonu(_ sender: Any) {
        let ilkSifre = sifreText.text
        let ikinciSifre = sifreTekrarText.text
        
        //kullanıcının boş bırakma ihtimali olduğu için if kullanıyoruz
        //Auth kullanarak veritabanında kullanıcı oluşturuyorum.Ve yazılanları .text dieyerk çekiyorum.
        
        
        
        
        if mailText.text != "" && sifreText.text != "" {
            
                
                
                Auth.auth().createUser(withEmail: mailText.text!, password: sifreText.text!) { (authdata, error ) in
                    if error != nil {
                        
                        self.makeAlert(titleGiris: "Error!", messageGiris: error!.localizedDescription)
                        
                    }
                    
                    else {
                        if ilkSifre != ikinciSifre {
                            self.makeAlert(titleGiris: "Error", messageGiris: "İki Şifre Aynı Değil !")
                        }
                        else {
                            //kullanıcı tüm herşeyi doğru girdiyse giriş sayfasına yönlendiriyorum.
                            let alert = UIAlertController(title: "E-mail hesabınızı doğrulayın!", message: "E-mail hesabınıza aktivasyon linki gönderildi.Doğruladıktan sonra giriş yapabilirsiniz.", preferredStyle: UIAlertController.Style.alert)
                            let tamamButton = UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.cancel){_ in
                                guard let user = authdata?.user, error == nil else {
                                    print(error?.localizedDescription ?? "Bilinmeyen hata")
                                    return
                                }
                                user.sendEmailVerification { (error) in
                                    if let error = error {
                                        print("E-posta gönderilmedi")
                                    }else {
                                        self.performSegue(withIdentifier: "kayitToGiris", sender: nil)
                                    }
                                }
                                
                            }
                            alert.addAction(tamamButton)
                            self.present(alert, animated: true)
                        }
                    }
                    
                }
                
                
            } else  {
                makeAlert(titleGiris: "Error!", messageGiris: "Kullanıcı adı ve Şifre giriniz.")
            }
            
        }
        
    
       
  
    func makeAlert(titleGiris:String, messageGiris:String) {
        let alert = UIAlertController(title: titleGiris, message: messageGiris, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "TAMAM", style: .cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    @objc func backButton () {
         self.dismiss(animated: true, completion: nil)
     }
}
