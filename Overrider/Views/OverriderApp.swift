//
//  OverriderApp.swift
//  Overrider
//
//  Created by Aram Soneson on 5/4/26.
//

import SwiftUI
import Combine
import Defaults
import KeyboardShortcuts

private var didRegisterShortcutHandlers: Bool = false

@main
struct OverriderApp: App {
	@Environment(\.openWindow) private var openWindow
	@Environment(\.openSettings) private var openSettings
	
	@StateObject private var interceptor: InputCatcher
	
	@State private var isEnabled: Bool = true
	@Default(.controlClickEnabled) var controlClickEnabled
	@Default(.shiftScrollEnabled) var shiftScrollEnabled
	
	@State private var permissionTimer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
	
	@Default(.showIconsInMenuBar) var showIconsInMenuBar
	@Default(.showVersionInMenuBar) var showVersionInMenuBar

	private var identity: String {
		let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
		let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
		return "Version \(version) (\(build))"
	}

	private func registerShortcutHandlers() {
		guard !didRegisterShortcutHandlers else {
			return
		}
		
		didRegisterShortcutHandlers = true
		
		KeyboardShortcuts.onKeyUp(for: .isEnabledShortcut) {
			isEnabled.toggle()
		}
		
		KeyboardShortcuts.onKeyUp(for: .controlClickEnabledShortcut) {
			guard isEnabled else {
				return
			}
			
			controlClickEnabled.toggle()
		}
		
		KeyboardShortcuts.onKeyUp(for: .shiftScrollEnabledShortcut) {
			guard isEnabled else {
				return
			}
			
			shiftScrollEnabled.toggle()
		}
	}
	
	init() {
		NSSplitViewItem.preventSplitViewCollapse()
		
		let newInterceptor = InputCatcher()
		var startSuccess = false

		do {
			try newInterceptor.start()
			startSuccess = true
			print("InputCatcher started successfully.")
		} catch {
			print("InputCatcher failed to start: \(error)")
		}

		_interceptor = StateObject(wrappedValue: newInterceptor)
		_isEnabled = State(initialValue: startSuccess)
	}

	var body: some Scene {
		MenuBarExtra {
			VStack {
				if !interceptor.getPermission() {
					Section {
						Text("Missing accessibility permission")
						
						Link(destination: URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!) {
							Label("Open Privacy Settings", systemImage: "eye")
						}
					}
				} else {
					Section {
						Toggle("Enabled", isOn: $isEnabled)
					}
					
					if isEnabled {
						Section {
							Label("Override behaviors", systemImage: showIconsInMenuBar ? "square.on.square.dashed" : "")
							
							Toggle("Override control-click", isOn: $controlClickEnabled)
							
							Toggle("Override shift-scroll", isOn: $shiftScrollEnabled)
						}
					}
				}
				
				Section {
					if showVersionInMenuBar {
						Label(identity, systemImage: showIconsInMenuBar ? "arrow.trianglehead.2.counterclockwise" : "")
					}
					
					Button("About Overrider", systemImage: showIconsInMenuBar ? "info.circle" : "") {
						openWindow(id: "about")
					}
					
					Button("Settings…", systemImage: showIconsInMenuBar ? "gearshape" : "") {
						openSettings()
					}
					.keyboardShortcut(",")
				}
				
				Section {
					Button("Quit", systemImage: showIconsInMenuBar ? "xmark.rectangle" : "", role: .destructive) {
						NSApplication.shared.terminate(nil)
					}
					.keyboardShortcut("q")
				}
			}
			.onReceive(permissionTimer) { _ in
				if interceptor.getPermission() && !interceptor.hasStartedOnce {
					do {
						try interceptor.start()
					} catch {
						print(error)
					}
				}
			}
		} label: {
			let config = NSImage.SymbolConfiguration(pointSize: 16, weight: .regular).applying(.init(scale: NSImage.SymbolScale(rawValue: 2)!))
			
			if let image = NSImage(named: "pointer.arrow.shield")?
				.withSymbolConfiguration(config) {
				Image(nsImage: image)
					.onAppear {
						registerShortcutHandlers()
					}
			} else {
				Image(systemName: "pointer.arrow.click.2")
					.onAppear {
						registerShortcutHandlers()
					}
			}
		}
		.onChange(of: isEnabled) {
			if isEnabled {
				do {
					try interceptor.start()
				} catch {
					isEnabled = false
				}
			} else {
				interceptor.stop()
			}
		}
		.onChange(of: controlClickEnabled) {
			interceptor.setEnableControlFix(controlClickEnabled)
		}
		.onChange(of: shiftScrollEnabled) {
			interceptor.setEnableShiftFix(shiftScrollEnabled)
		}
		
		Window("About Overrider", id: "about") {
			AboutView()
				.frame(maxWidth: 550, maxHeight: 300)
				.windowMinimizeBehavior(.disabled)
				.windowResizeBehavior(.disabled)
		}
		.windowResizability(.contentSize)
		.windowLevel(.floating)
		.commands {
			CommandGroup(replacing: CommandGroupPlacement.appInfo) {
				Button {
					openWindow(id: "about")
				} label: {
					Label("About Overrider", systemImage: "info.circle")
				}
			}
		}
		
		Settings {
			SettingsView(
				isEnabled: $isEnabled,
				controlClickEnabled: $controlClickEnabled,
				shiftScrollEnabled: $shiftScrollEnabled,
				showIconsInMenuBar: $showIconsInMenuBar,
				showVersionInMenuBar: $showVersionInMenuBar
			)
			.frame(maxWidth: 400)
		}
		.windowResizability(.contentSize)
		.windowLevel(.floating)
	}
}
