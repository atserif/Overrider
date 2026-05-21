//
//  SettingsView.swift
//  Overrider
//
//  Created by Aram Soneson on 5/12/26.
//

import SwiftUI

struct SettingsView: View {
	@Binding var isEnabled: Bool
	@Binding var controlClickEnabled: Bool
	@Binding var shiftScrollEnabled: Bool
	
	@Binding var showIconsInMenuBar: Bool
	@Binding var showVersionInMenuBar: Bool
	
	@State private var tabSelection: Int = 0
	
    var body: some View {
		// TODO: Make settings window resize for different tabs around content. Doesn't seem to work very will with .formStyle(.grouped) for some reason
		TabView(selection: $tabSelection.animation()) {
			Tab("General", systemImage: "gearshape", value: 0) {
				GeneralSettingsView()
					.fixedSize(horizontal: false, vertical: true)
			}
			
			Tab("Shortcuts", systemImage: "keyboard", value: 1) {
				ShortcutsSettingsView(
					isEnabled: $isEnabled,
					controlClickEnabled: $controlClickEnabled,
					shiftScrollEnabled: $shiftScrollEnabled
				)
				.fixedSize(horizontal: false, vertical: true)
			}
			
			Tab("Advanced", systemImage: "gearshape.2", value: 2) {
				AdvancedSettingsView(
					showIconsInMenuBar: $showIconsInMenuBar,
					showVersionInMenuBar: $showVersionInMenuBar
				)
				.fixedSize(horizontal: false, vertical: true)
			}
		}
		.windowResizeAnchor(.top)
    }
}

#Preview {
	@State @Previewable var previewIsEnabled: Bool = true
	@State @Previewable var previewControlClickEnabled: Bool = true
	@State @Previewable var previewShiftScrollEnabled: Bool = true
	
	@State @Previewable var previewShowVersionInMenuBar: Bool = true
	@State @Previewable var previewShowIconsInMenuBar: Bool = true
	
	SettingsView(
		isEnabled: $previewIsEnabled,
		controlClickEnabled: $previewControlClickEnabled,
		shiftScrollEnabled: $previewShiftScrollEnabled,
		showIconsInMenuBar: $previewShowIconsInMenuBar,
		showVersionInMenuBar: $previewShowVersionInMenuBar
	)
}
