//
//  ViewController.swift
//  PitchPerfectV2
//
//  Created by Toluwani Ogunsanya on 2020-05-04.
//  Copyright © 2020 Toluwani Ogunsanya. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.isEnabled = false
    }


    @IBAction func recordButtonPressed(_ sender: Any) {
        recordLabel.text = "Stop Recording"
        recordButton.isEnabled = false
        stopButton.isEnabled = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
          let recordingName = "recordedVoice.wav"
          let pathArray = [dirPath, recordingName]
          let filePath = URL(string: pathArray.joined(separator: "/"))

          let session = AVAudioSession.sharedInstance()
          try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

          try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
          audioRecorder.delegate = self
          audioRecorder.isMeteringEnabled = true
          audioRecorder.prepareToRecord()
          audioRecorder.record()
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        recordLabel.text = "Start Recording"
        recordButton.isEnabled = true
        stopButton.isEnabled = false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("finished recording")
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlayAudioViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

