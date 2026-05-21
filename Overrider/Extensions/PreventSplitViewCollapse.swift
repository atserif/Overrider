//
//  PreventSplitViewCollapse.swift
//  Overrider
//
//  Created by Aram Soneson on 5/8/26.
//

import SwiftUI

extension NSSplitViewItem {
    @objc private var canCollapseSwizzled: Bool { false }

    static func preventSplitViewCollapse() {
        guard
            let original = class_getInstanceMethod(self, #selector(getter: NSSplitViewItem.canCollapse)),
			let swizzled = class_getInstanceMethod(self, #selector(getter: NSSplitViewItem.canCollapseSwizzled))
        else { return }
		
        method_exchangeImplementations(original, swizzled)
    }
}
