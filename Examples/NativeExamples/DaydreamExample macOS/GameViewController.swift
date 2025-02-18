//
//  GameViewController.swift
//  DaydreamExample macOS
//
//  Created by fuziki on 2021/06/26.
//

import Cocoa
import SceneKit

class GameViewController: NSViewController {
    
    @IBOutlet weak var gameView: SCNView!
    @IBOutlet weak var label: NSTextField!
    
    private var gameController: GameController!
    private let bluetoothService = BluetoothService.shared
    
    private var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gameController = GameController(sceneRenderer: gameView)
        
        // Allow the user to manipulate the camera
        self.gameView.allowsCameraControl = true
        
        // Show statistics such as fps and timing information
        self.gameView.showsStatistics = true
        
        // Configure the view
        self.gameView.backgroundColor = NSColor.black
        
        // Add a click gesture recognizer
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        var gestureRecognizers = gameView.gestureRecognizers
        gestureRecognizers.insert(clickGesture, at: 0)
        self.gameView.gestureRecognizers = gestureRecognizers
        
        bluetoothService.onUpdateValue = { [weak self] (value: String) in
            DispatchQueue.main.async { [weak self] in
                self?.label.stringValue = value
            }
        }
        bluetoothService.start()
    }
    
    @objc
    func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        // Highlight the clicked nodes
        let p = gestureRecognizer.location(in: gameView)
        gameController.highlightNodes(atPoint: p)
    }
    
    @IBAction func onPressButtonAction(_ sender: Any) {
        print("write: \(count)")
        bluetoothService.write(data: "c\(count)".data(using: .utf8)!)
        count += 1
    }
}
