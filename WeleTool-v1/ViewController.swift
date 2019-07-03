//
//  ViewController.swift
//  WeleTool-v1
//
//  Created by Kien Nguyen on 03/07/2019.
//  Copyright © 2019 Kien Nguyen. All rights reserved.
//


import Cocoa
import AVFoundation

class ViewController: NSViewController {
    
    @IBOutlet weak var filename_field: NSTextField!
    @IBOutlet weak var playValue: NSTextField!
    
    
    @IBOutlet weak var timeValue: NSTextField!
    
    var audioPlayer = AVAudioPlayer()
    var value : String = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        gettingSongName()
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) {
            self.flagsChanged(with: $0)
            return $0
        }
        
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    func gettingSongName()
    {
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        do{
            let songPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for song in songPath
            {
                var mySong = song.absoluteString
                if mySong .contains(".mp3"){
                    let findString = mySong.components(separatedBy: "/")
                    mySong = findString[findString.count-1]
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ")
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    print(mySong)
                }
            }
        }
        catch
        {
            
        }
        
    }
    @IBAction func browseFile(sender: AnyObject) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a .txt file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["mp3"];
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                filename_field.stringValue = path
                do
                {
                    
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                    audioPlayer.enableRate = true
                    var timer =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimeleft), userInfo: nil, repeats: true)
                    
                    
                    
                }
                catch
                {
                    print(error)
                }
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        
    }
    /*func playMusic(){
     let sound = Bundle.main.path(forResource: "song/Spotlight", ofType: "mp3")
     do
     {
     
     audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
     }
     catch
     {
     print(error)
     }
     
     }
     */
    
    @IBAction func buttonPlay(_ sender: Any) {
        audioPlayer.play()
        
    }
    @IBAction func buttonPause(_ sender: Any) {
        audioPlayer.pause()
    }
    override func flagsChanged(with event: NSEvent) {
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [.control]:
            audioPlayer.pause()
        case [.shift, .option]:
            audioPlayer.stop()
            audioPlayer.rate = 1
            audioPlayer.play()
        case [.option]:
            if audioPlayer.isPlaying
            {
                audioPlayer.stop()
                value = playValue.stringValue
                audioPlayer.currentTime = audioPlayer.currentTime - TimeInterval(Double(value)!)
                audioPlayer.play()
                
            }
        default:
            print("no modifier keys are pressed")
        }
    }
    @objc func updateTimeleft(){
        
        // let timeLeft = TimeInterval(audioPlayer.duration - audioPlayer.currentTime)
        
        // update your UI with timeLeft
        let duration = Int((audioPlayer.duration - (audioPlayer.currentTime)))
        let minutes2 = duration/60
        let seconds2 = duration - minutes2 * 60
        timeValue.stringValue = NSString(format: "%02d:%02d", minutes2,seconds2) as String
        
        
    }
    
}


