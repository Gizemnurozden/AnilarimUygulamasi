//
//  FavorilerHucre.swift
//  NotlarimUygulamasi
//
//  Created by Gizemnur Özden & Ogün Minkara
//

import UIKit

class FavorilerHucre: UITableViewCell {

    
    
    @IBOutlet weak var hucreArkaPlan: UIView!
    @IBOutlet weak var imageViewSecilen: UIImageView!
    @IBOutlet weak var anibaslikFavori: UILabel!
    @IBOutlet weak var tarihVeSaatFavori: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
