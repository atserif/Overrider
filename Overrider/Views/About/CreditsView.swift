//
//  CreditsView.swift
//  Overrider
//
//  Created by Aram Soneson on 5/11/26.
//

import SwiftUI

struct CreditsView: View {
	@Binding var appInfo: Program
	@Binding var technologies: [Program]
	
    var body: some View {
		ScrollView {
			VStack(alignment: .center, spacing: 24) {
				VStack(alignment: .center, spacing: 6) {
					Text(appInfo.name)
						.foregroundStyle(.secondary)
						.fontWeight(.semibold)
					
					HStack(spacing: 4) {
						Text(appInfo.author)
							.textSelection(.enabled)
						
						Link(destination: URL(string: appInfo.authorUrl)!) {
							Image(systemName: "link")
						}
						.foregroundStyle(.tint)
					}
				}
				
				ResourcesView(
					technologies: $technologies
				)
				
				VStack(alignment: .center, spacing: 6) {
					Text("\(appInfo.name) is an open source project licensed under the \(appInfo.license).")
						.textSelection(.enabled)
					
					Link(destination: URL(string: appInfo.url)!) {
						Text(appInfo.url.trimmingPrefix("https://"))
					}
					.foregroundStyle(.tint)
				}
			}
			.padding()
			.font(.subheadline)
			.multilineTextAlignment(.center)
			.lineSpacing(2)
		}
    }
}

struct ResourcesView: View {
	@Binding var technologies: [Program]
	
	var body: some View {
		VStack(alignment: .center, spacing: 6) {
			Text("Resources")
				.foregroundStyle(.secondary)
				.fontWeight(.semibold)
			
			Grid(alignment: .leadingFirstTextBaseline, verticalSpacing: 4) {
				ForEach(technologies.indices, id: \.self) { index in
					GridRow {
						Text(technologies[index].purpose)
							.foregroundStyle(.secondary)
							.gridColumnAlignment(.trailing)
						
						HStack(spacing: 4) {
							Text(technologies[index].author)
								.textSelection(.enabled)
							
							Link(destination: URL(string: technologies[index].authorUrl)!) {
								Image(systemName: "link")
							}
							.foregroundStyle(.tint)
						}
					}
				}
			}
		}
	}
}

#Preview {
	@State @Previewable var previewAppInfo: Program = Program(
		name: "Overrider",
		   author: "atserif",
		   authorUrl: "https://github.com/atserif",
		   url: "https://github.com/atserif/Overrider",
		   purpose: "",
		   copyright: "Copyright © 2026 atserif",
		   license: "GNU General Public License, Version 3"
	   )
	
	@State @Previewable var previewTechnologies: [Program] = [
		Program(
			name: "TakeCtrl",
			author: "zacheri04",
			authorUrl: "https://github.com/zacheri04",
			url: "https://github.com/zacheri04/TakeCtrl",
			purpose: "Input override logic",
			copyright: "Copyright © zacheri04",
			license: ""
		),
		
		Program(
			name: "Defaults",
			author: "sindresorhus",
			authorUrl: "https://github.com/sindresorhus",
			url: "https://github.com/sindresorhus/Defaults",
			purpose: "Persistent data storage",
			copyright: "Copyright © Sindre Sorhus",
			license: "MIT License"
		),
		
		Program(
			name: "KeyboardShortcuts",
			author: "sindresorhus",
			authorUrl: "https://github.com/sindresorhus",
			url: "https://github.com/sindresorhus/KeyboardShortcuts",
			purpose: "Global keybinds",
			copyright: "Copyright © Sindre Sorhus",
			license: "MIT License"
		),
		
		Program(
			name: "LaunchAtLogin",
			author: "sindresorhus",
			authorUrl: "https://github.com/sindresorhus",
			url: "https://github.com/sindresorhus/LaunchAtLogin-Modern",
			purpose: "Login item functionality",
			copyright: "Copyright © Sindre Sorhus",
			license: "MIT License"
		),
		
		Program(
			name: "CotEditor",
			author: "1024jp",
			authorUrl: "https://github.com/1024jp",
			url: "https://github.com/coteditor/CotEditor",
			purpose: "About window design",
			copyright:
				"""
				Copyright © 2005–2009 nakamuxu
				Copyright © 2011, 2014 usami-k
				Copyright © 2013–2026 1024jp
				""",
			license: "Apache License, Version 2.0"
		)
	]
	
	CreditsView(
		appInfo: $previewAppInfo,
		technologies: $previewTechnologies
	)
}
