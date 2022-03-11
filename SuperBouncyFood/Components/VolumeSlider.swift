//
//  VolumeSlider.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 08/03/22.
//

import UIKit
import MediaPlayer

class VolumeSlider: MPVolumeView {

    
    func createSlider(uiView: UIView, viewAdd: UIViewController){
        let mpVolumeHolderView = uiView
        mpVolumeHolderView.backgroundColor = .clear

        let mpVolume = MPVolumeView(frame: mpVolumeHolderView.bounds)
        mpVolume.tintColor = UIColor(named: "coxinha")
        mpVolume.showsRouteButton = false
        mpVolumeHolderView.addSubview(mpVolume)
        viewAdd.view.addSubview(mpVolumeHolderView)
    }
    

}
