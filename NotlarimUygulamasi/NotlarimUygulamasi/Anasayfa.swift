//
//  Anasayfa.swift
//  NotlarimUygulamasi
//
//   Created by Gizemnur Özden & Ogün Minkara 
//

import UIKit

class Anasayfa: UIViewController {

    @IBOutlet weak var imageAniEkle: UIImageView!
    @IBOutlet weak var imageAnilarim: UIImageView!
    @IBOutlet weak var imageHarita: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //görünümler
        imageAniEkle.layer.cornerRadius = 15
        imageAnilarim.layer.cornerRadius = 15
        imageHarita.layer.cornerRadius = 15
        
        imageAniEkle.clipsToBounds = false
        imageAniEkle.layer.borderColor = UIColor.systemBlue.cgColor
        imageAniEkle.layer.shadowColor = UIColor.black.cgColor
        imageAniEkle.layer.shadowOpacity = 1.2
        imageAniEkle.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageAniEkle.layer.shadowRadius = 10
        
        imageAnilarim.clipsToBounds = false
        imageAnilarim.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageAnilarim.layer.shadowColor = UIColor.black.cgColor
        imageAnilarim.layer.shadowOpacity = 1.2
        imageAnilarim.layer.shadowRadius = 10
        
        imageHarita.clipsToBounds = false
        imageHarita.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageHarita.layer.shadowColor = UIColor.black.cgColor
        imageHarita.layer.shadowOpacity = 1.2
        imageHarita.layer.shadowRadius = 10
        
        self.view.addSubview(imageAniEkle)
        
//ani ekle tıklanabilirlik yapıldı.
        imageAniEkle.isUserInteractionEnabled = true
        let aniEkleTiklama = UITapGestureRecognizer(target: self, action: #selector(aniEkleGecis))
        imageAniEkle.addGestureRecognizer(aniEkleTiklama)
        
// Anilarim tıklanabilirlik ve geçiş yapıldı.
        
       imageAnilarim.isUserInteractionEnabled = true
       let anilarimTiklama = UITapGestureRecognizer(target: self, action: #selector(anilarimGecis))
       imageAnilarim.addGestureRecognizer(anilarimTiklama)
        
// harita resminin tıklanabilir olması için gereken işlemler ;
// imageHarita , haritaGecis fonksiyonları eklendi.
        
        imageHarita.isUserInteractionEnabled = true
        let haritaTiklama = UITapGestureRecognizer(target: self, action: #selector(haritaGecis))
        imageHarita.addGestureRecognizer(haritaTiklama)
    }
    
    @objc func haritaGecis() {
        
        performSegue(withIdentifier: "haritamGecis", sender: nil)
    
    }
   
    @objc func aniEkleGecis() {
        performSegue(withIdentifier: "toAniEkleVC", sender: nil)
    }
    
    @objc func anilarimGecis() {
     performSegue(withIdentifier: "toAnilarimVC", sender: nil)
 }

}
