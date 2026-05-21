//
//  AdvancedSettingsView.swift
//  Overrider
//
//  Created by Aram Soneson on 5/12/26.
//

import SwiftUI

struct AdvancedSettingsView: View {
	@Binding var showIconsInMenuBar: Bool
	@Binding var showVersionInMenuBar: Bool
	
    var body: some View {
		Form {
			Toggle("Show icons in menu bar item", isOn: $showIconsInMenuBar)
			
			Toggle("Show version number in menu bar item", isOn: $showVersionInMenuBar)
		}
		.formStyle(.grouped)
    }
}

#Preview {
	@State @Previewable var previewShowVersionInMenuBar: Bool = true
	@State @Previewable var previewShowIconsInMenuBar: Bool = true
	
	AdvancedSettingsView(
		showIconsInMenuBar: $previewShowIconsInMenuBar,
		showVersionInMenuBar: $previewShowVersionInMenuBar
	)
}
