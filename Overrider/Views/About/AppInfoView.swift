//
//  AppInfoView.swift
//  Overrider
//
//  Created by Aram Soneson on 5/18/26.
//

import SwiftUI

struct AppInfoView: View {
	private var identity: String {
		let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
		let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
		return "Version \(version) (\(build))"
	}
	
	var body: some View {
		VStack {
			Spacer()
			
			Image("AppIcon")
				.resizable()
				.scaledToFit()
				.frame(width: 110, height: 110)
				.padding(8)
			
			VStack(spacing: 6) {
				Text("Overrider")
					.font(.title)
					.fontWeight(.semibold)
				
				Text(identity)
					.font(.subheadline)
				
				Text("Copyright © 2026 atserif")
					.foregroundStyle(.secondary)
					.font(.subheadline)
			}
			
			Spacer()
		}
		.ignoresSafeArea()
		.textSelection(.enabled)
		.multilineTextAlignment(.center)
		.toolbar(removing: .sidebarToggle)
		.navigationSplitViewColumnWidth(200)
	}
}

#Preview {
	AppInfoView()
}
