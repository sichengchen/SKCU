//
//  ContentView.swift
//  SKCU
//
//  Created by Sicheng Chen on 11/8/23.
//

import SwiftUI

var eventTap: CFMachPort?

func blockKeyboard() {
    let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue)
    eventTap = CGEvent.tapCreate(tap: .cgAnnotatedSessionEventTap,
                                 place: .headInsertEventTap,
                                 options: .defaultTap,
                                 eventsOfInterest: CGEventMask(eventMask),
                                 callback: { (_, _, _, _) -> Unmanaged<CGEvent>? in return nil },
                                 userInfo: nil)
    if let eventTap = eventTap {
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
    } else {
        print("Failed to create event tap")
    }
}

func releaseKeyboard() {
    if let eventTap = eventTap {
        CGEvent.tapEnable(tap: eventTap, enable: false)
    }
}

struct ContentView: View {
    @State var isKeyboardBlocked : Bool = false
    @State var isFullScreenBlack : Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Label("Keyboard", systemImage: "keyboard")
                    .font(.title2)
                
                Toggle(isOn: $isKeyboardBlocked, label: {
                    Text("Lock")
                })
                .onChange(of: isKeyboardBlocked, {
                    if (isFullScreenBlack) {
                        isFullScreenBlack.toggle()
                    }
                    
                    if (isKeyboardBlocked) {
                        blockKeyboard()
                    } else {
                        releaseKeyboard()
                    }
                })
                .toggleStyle(.switch)
            }
            .padding()
            
            VStack {
                Label("Screen", systemImage: "display")
                    .font(.title2)
                
                Button("Black") {
                    if (isKeyboardBlocked) {
                        releaseKeyboard()
                        isKeyboardBlocked.toggle()
                    }
                    
                    isFullScreenBlack.toggle()
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
