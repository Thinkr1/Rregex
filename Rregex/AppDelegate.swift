//
//  AppDelegate.swift
//  Rregex
//
//  Created by Pierre-Louis ML on 09/02/2025.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "f.cursive", accessibilityDescription: "Regex Tester")
            button.action = #selector(togglePopover(_:))
        }

        popover = NSPopover()
        popover?.contentViewController = NSHostingController(rootView: MenuBarItemView())
        popover?.behavior = .transient
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusItem?.button {
            if popover?.isShown == true {
                popover?.performClose(sender)
            } else {
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
