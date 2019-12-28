//
//  ViewController.swift
//  autoclicker
//
//  Created by Apple on 2019/12/28.
//  Copyright © 2019 Apple. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    override var acceptsFirstResponder: Bool { return true }
    override func becomeFirstResponder() -> Bool { return true }
    override func resignFirstResponder() -> Bool { return true }
    
    lazy var window: NSWindow = self.view.window!
    var mouseLocation: NSPoint { NSEvent.mouseLocation }
    var location: NSPoint { window.mouseLocationOutsideOfEventStream }
    var remained: Int = 0
    
    
    @IBOutlet weak var speedNum: NSTextField!
    @IBOutlet weak var clickCount: NSTextField!
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var remainedCount: NSTextField!
    
    
    @IBAction func modifyCount(_ sender: Any) {
        let count = NSDecimalNumber.init(string: self.clickCount.stringValue).intValue
        self.setRemainedCount(c: count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        NSEvent.addGlobalMonitorForEvents(matching: .keyDown, handler: self.keyDown)
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        window.acceptsMouseMovedEvents = true
    }
    
    override func keyDown(with event: NSEvent) {
        print(event.keyCode)
        if event.keyCode == 96 {
             switchStatus()
         }
    }
    
    @IBAction func clickButton(_ sender: Any) {
        switchStatus()
    }
    
    func switchStatus() {
        if self.remained > 0  {
            self.setRemainedCount(c:0)
        } else {
            let count = NSDecimalNumber.init(string: self.clickCount.stringValue).intValue
            self.setRemainedCount(c: count)
            simulateMouseClick()
        }
    }
    
    func setRemainedCount(c: Int)  {
        self.remained = c
        self.remainedCount.stringValue = String(c)
    }
    
    func simulateMouseClick() {
        if self.remained <= 0 {
            return
        }
        
        self.setRemainedCount(c: self.remained - 1)
        
        let source = CGEventSource.init(stateID: .hidSystemState)
        let point = CGPoint(x:self.mouseLocation.x, y:self.mouseLocation.y)
        let mouseDown = CGEvent(mouseEventSource: source, mouseType: .leftMouseDown, mouseCursorPosition: point, mouseButton: .left)
//        let mouseUp = CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: point, mouseButton: .left)
        
        let sec = NSDecimalNumber.init(string: self.speedNum.stringValue).intValue*1000
        
        mouseDown?.post(tap: .cghidEventTap)
        usleep(useconds_t(sec))
        
        //        mouseUp?.post(tap: .cghidEventTap)
        //        usleep(useconds_t(sec))
        
        
        simulateMouseClick()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}

