//
//  AnilarimHucre.swift
//  NotlarimUygulamasi
//
//  Created by Gizemnur Özden on 24.12.2023.
//

import UIKit
import Firebase

protocol AnilarimHucreDelegate: AnyObject {
    
    func switchValueChanged(forCell cell: AnilarimHucre, switchValue: Bool)
    
}


class AnilarimHucre: UITableViewCell {

  
    //Tableviewde hücre görüntüsü için açıldı.
    
    weak var delegate: AnilarimHucreDelegate?

    @IBOutlet weak var switchAniDurumu: UISwitch!
    
    @IBOutlet weak var documentIdLabel: UILabel!
    
    @IBOutlet weak var imageViewSecilen: UIImageView!
    
    @IBOutlet weak var aniBaslikLabel: UILabel!
    
    @IBOutlet weak var tarihVeSaatLabel: UILabel!
    
    @IBOutlet weak var hucreArkaPlan: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
//Anılarım hücresindeki switch kısmını kaydırınca veritabanındaki değerini değiştirme kodları eklendi.
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        let fireStoreDatabase = Firestore.firestore()
        
            let favoriCount = switchAniDurumu.isOn
            
            let favoriStore = ["likes" : favoriCount] as [String : Any ]
            fireStoreDatabase.collection("Anilar").document(documentIdLabel.text!).setData(favoriStore, merge: true)
        
            print("değişti")
        }
    
}
