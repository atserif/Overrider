//
//  ShortcutsSettingsView.swift
//  Overrider
//
//  Created by Aram Soneson on 5/14/26.
//

import SwiftUI
import KeyboardShortcuts

struct ShortcutsSettingsView: View {
	@Binding var isEnabled: Bool
	@Binding var controlClickEnabled: Bool
	@Binding var shiftScrollEnabled: Bool
	
	var body: some View {
		Form {
			KeyboardShortcuts.Recorder("Toggle all functionality", name: .isEnabledShortcut)
			
			KeyboardShortcuts.Recorder("Toggle control-click override", name: .controlClickEnabledShortcut)
			
			KeyboardShortcuts.Recorder("Toggle shift-scroll override", name: .shiftScrollEnabledShortcut)
		}
		.formStyle(.grouped)
	}
}

#Preview {
	@State @Previewable var previewIsEnabled: Bool = true
	@State @Previewable var previewControlClickEnabled: Bool = true
	@State @Previewable var previewShiftScrollEnabled: Bool = true
	
	ShortcutsSettingsView(
		isEnabled: $previewIsEnabled,
		controlClickEnabled: $previewControlClickEnabled,
		shiftScrollEnabled: $previewShiftScrollEnabled
	)
}
