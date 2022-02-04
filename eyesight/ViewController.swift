//
//  ViewController.swift
//  eyesight
//
//  Created by Vincent Cloutier on 2022-02-03.
//

import UIKit
import Lumina
import AVFoundation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let camera = LuminaViewController()
        camera.textPrompt = ""
        camera.setCancelButton(visible: false)
        camera.setShutterButton(visible: false)
        camera.setSwitchButton(visible: false)
        camera.setTorchButton(visible: false)
        camera.frameRate = 24
        camera.streamingModels = [LuminaModel(model: MobileNet().model, type: "MobileNet")]
        camera.delegate = self
        present(camera, animated: true, completion: nil)
    }
}

extension ViewController: LuminaDelegate {
    func dismissed(controller: LuminaViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func streamed(videoFrame: UIImage, with predictions: [LuminaRecognitionResult]?, from controller: LuminaViewController) {
        guard let predicted = predictions else {
            return
        }
        
        var resultString = String()
        
        for prediction in predicted {
            guard let values = prediction.predictions else {
                continue
            }
            guard let bestPrediction = values.first else {
                continue
            }
            resultString.append("\(bestPrediction.name.capitalized)")
        }
        controller.textPrompt = resultString
    }
}

