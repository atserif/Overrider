//
//  Defaults.swift
//  Overrider
//
//  Created by Aram Soneson on 5/15/26.
//

import Defaults

extension Defaults.Keys {
	static let controlClickEnabled = Key<Bool>("controlClickEnabled", default: false)
	static let shiftScrollEnabled = Key<Bool>("shiftScrollEnabled", default: false)
	
	static let showIconsInMenuBar = Key<Bool>("showIconsInMenuBar", default: true)
	static let showVersionInMenuBar = Key<Bool>("showVersionInMenuBar", default: true)
}
