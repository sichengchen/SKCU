//
//  BlackScreenSaverView.swift
//  SKCU
//
//  Created by Sicheng Chen on 11/8/23.
//

import SwiftUI

struct BlackScreenSaverView: View {
    @Binding var isActive: Bool

    var body: some View {
        MouseListeningView {
            // Action to perform when mouse moves
            self.isActive = false
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            NSCursor.hide()
        }
        .onDisappear {
            NSCursor.unhide()
        }
    }
}

struct MouseListeningView: NSViewRepresentable {
    var onMove: () -> Void

    func makeNSView(context: Context) -> NSView {
        let view = CustomNSView()
        view.onMove = onMove
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

class CustomNSView: NSView {
    var onMove: (() -> Void)?

    override func resetCursorRects() {
        addCursorRect(bounds, cursor: .arrow)
    }

    override func mouseMoved(with event: NSEvent) {
        onMove?()
    }

    override func viewDidMoveToWindow() {
        guard let window = window else { return }
        window.acceptsMouseMovedEvents = true
        window.makeFirstResponder(self)
    }
}
