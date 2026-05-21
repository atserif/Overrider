//
//  GeneralSettingsView.swift
//  Overrider
//
//  Created by Aram Soneson on 5/12/26.
//

import SwiftUI
import LaunchAtLogin

struct GeneralSettingsView: View {
    var body: some View {
		Form {
			LaunchAtLogin.Toggle()
		}
		.formStyle(.grouped)
    }
}

#Preview {	
    GeneralSettingsView()
}
