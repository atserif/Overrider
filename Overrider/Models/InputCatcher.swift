//
//  InputCatcher.swift
//  Overrider
//
//  Created by Aram Soneson on 5/4/26.
//

import Combine
import ApplicationServices
import CoreGraphics

enum InputCatcherError: Error {
	case failedToCreateEventTap
}

private func globalEventCallback(
	proxy: CGEventTapProxy,
	type: CGEventType,
	event: CGEvent,
	refcon: UnsafeMutableRawPointer?
) -> Unmanaged<CGEvent>? {
	if type == .leftMouseDown || type == .leftMouseUp {
		let flags = event.flags
		if flags.contains(.maskControl) {
			let newFlags = flags.subtracting(.maskControl)
			event.flags = newFlags
			return Unmanaged.passRetained(event)
		}
	}
	
	if type == .scrollWheel {
		let flags = event.flags
		if flags.contains(.maskShift) {
			let newFlags = flags.subtracting(.maskShift)
			event.flags = newFlags
			return Unmanaged.passRetained(event)
		}
	}
	
	return Unmanaged.passRetained(event)
}

class InputCatcher: ObservableObject {
	private var eventTap: CFMachPort?
	private var runLoopSource: CFRunLoopSource?
	private var enableControlFix = false
	private var enableShiftFix = false
	private var eventMask: UInt32 = 0

	@Published var isRunning = false
	@Published var hasStartedOnce = false

	func start() throws {
		guard !isRunning else { return }
		guard let tap = CGEvent.tapCreate(
			tap: .cgSessionEventTap,
			place: .headInsertEventTap,
			options: .defaultTap,
			eventsOfInterest: CGEventMask(eventMask),
			callback: globalEventCallback,
			userInfo: nil
		) else {
			throw InputCatcherError.failedToCreateEventTap
		}

		self.eventTap = tap
		let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
		self.runLoopSource = source
		
		CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
		CGEvent.tapEnable(tap: tap, enable: true)

		isRunning = true
		hasStartedOnce = true
	}

	func stop() {
		guard isRunning, let tap = eventTap, let source = runLoopSource else {
			return
		}
		
		CGEvent.tapEnable(tap: tap, enable: false)
		CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .commonModes)

		self.eventTap = nil
		self.runLoopSource = nil
		self.isRunning = false
	}

	func getPermission() -> Bool {
		return AXIsProcessTrusted()
	}

	func setEnableControlFix(_ enable: Bool) {
		self.enableControlFix = enable
		updateEventMask()
	}

	func setEnableShiftFix(_ enable: Bool) {
		self.enableShiftFix = enable
		updateEventMask()
	}

	private func updateEventMask() {
		if self.enableShiftFix && self.enableControlFix {
			self.eventMask = (1 << CGEventType.scrollWheel.rawValue) | (1 << CGEventType.leftMouseDown.rawValue)
			| (1 << CGEventType.leftMouseUp.rawValue)
		}
		else if self.enableControlFix && !self.enableShiftFix {
			self.eventMask = (1 << CGEventType.leftMouseDown.rawValue)
				| (1 << CGEventType.leftMouseUp.rawValue)
		}
		else if self.enableShiftFix && !self.enableControlFix {
			self.eventMask = (1 << CGEventType.scrollWheel.rawValue)
		} else {
			self.eventMask = 0
		}
		
		self.stop()
		do {
			try self.start()
		} catch {
			print(error)
		}
	}
}
