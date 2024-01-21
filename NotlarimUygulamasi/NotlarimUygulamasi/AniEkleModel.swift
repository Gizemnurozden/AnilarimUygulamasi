//
//  AniEkleModel.swift
//  NotlarimUygulamasi
//
//  Created by Gizemnur Özden on 20.01.2024.
//


//SİNGLETON YAPISINDA SINIF HER SINIFTAN ERİŞİLEBİLİR.
import Foundation
import UIKit
class AniEkleModel {
    
    static let sharedIntance = AniEkleModel()
    
    var anibaslik = ""
    var tarihvesaat = ""
    var not = ""
    var secilenImage = UIImage()
    var secilenEnlem = ""
    var secilenBoylam = ""
    
    private init() {}
    
}
