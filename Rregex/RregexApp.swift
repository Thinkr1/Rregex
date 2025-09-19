//
//  RregexApp.swift
//  Rregex
//
//  Created by Pierre-Louis ML on 04/01/2025.
//

import SwiftUI
import AppKit

@main
struct RregexApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ZStack{
                VisualEffectBlurView()
                ContentView()
            }.toolbarBackgroundVisibility(.hidden)
            .onAppear {
                modifyWindowAppearance()
            }
        }//.windowStyle(HiddenTitleBarWindowStyle())
            .windowStyle(.hiddenTitleBar)
            .windowToolbarStyle(.unifiedCompact)
    }
    
    private func modifyWindowAppearance() {
        DispatchQueue.main.async {
            NSApplication.shared.windows.forEach { w in
                w.backgroundColor = .clear
                w.isOpaque = false
                w.isMovableByWindowBackground = true
                w.titlebarAppearsTransparent = true
                w.titleVisibility = .hidden
                w.styleMask.insert(.fullSizeContentView)
                
                if let tv = w.standardWindowButton(.closeButton)?.superview {
                    tv.subviews
                        .filter { $0 is NSVisualEffectView }
                        .forEach { $0.removeFromSuperview() }
                    
                    let ve = NSVisualEffectView()
                    ve.material = .sidebar
                    ve.blendingMode = .behindWindow
                    ve.state = .active
                    ve.frame = tv.bounds
                    ve.autoresizingMask = [.width, .height]
                    tv.addSubview(ve, positioned: .below, relativeTo: nil)
                }
//                if let existingBlur = tv.subviews.first(where: { $0 is NSVisualEffectView }) {
//                    existingBlur.removeFromSuperview()
//                }
//                
//                let ve = NSVisualEffectView()
//                ve.material = .menu
//                ve.blendingMode = .behindWindow
//                ve.state = .active
//                ve.frame = tv.bounds
//                ve.autoresizingMask = [.width, .height]
//
//                tv.addSubview(ve, positioned: .below, relativeTo: nil)
            }
        }
    }
}


struct VisualEffectBlurView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let ve = NSVisualEffectView()
        ve.material = .menu
        ve.blendingMode = .behindWindow
        ve.state = .active
        ve.autoresizingMask = [.width, .height]
        
        return ve
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
