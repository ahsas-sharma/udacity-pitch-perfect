//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Ahsas Sharma on 10/06/17.
//  Copyright © 2017 Ahsas Sharma. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {

    // MARK: - Outlets -
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK: - Properties -
    
    var audioRecorder: AVAudioRecorder!
    
    // MARK:- View Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        stopRecordingButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        configureRecordingUI(isRecording: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK:- Recording Functions -
    
    @IBAction func recordAudio(_ sender: Any) {
        configureRecordingUI(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureRecordingUI(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: - UI Functions -
    
    func configureRecordingUI(isRecording: Bool) {
            stopRecordingButton.isEnabled = isRecording
            recordButton.isEnabled = !isRecording
            recordingLabel.text = isRecording ? "Recording in Progress" : "Tap to Record"
    }
}

// MARK: - RecordSoundsViewController: AVAudioRecorderDelegate -

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            let alertController = UIAlertController(title: "🙈 Sorry!", message: "There was some issue while trying to save your recording. Please try again.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
