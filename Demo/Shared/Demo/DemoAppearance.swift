//
//  DemoAppearance.swift
//  Demo
//
//  Created by Daniel Saidi on 2020-12-07.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#endif

final class DemoAppearance {
    
    private init() {}
    
    static func apply() {
        #if os(iOS)
        if #available(iOS 13.0, *) {
            let navbar = UINavigationBar.appearance()
            let navbarAppearance = UINavigationBarAppearance()
            var titleTextAttributes = navbarAppearance.titleTextAttributes
            titleTextAttributes[.font] = UIFont(name: "Knewave-Regular", size: 20)!
            navbarAppearance.titleTextAttributes = titleTextAttributes
            
            var largeTitleTextAttributes = navbarAppearance.largeTitleTextAttributes
            largeTitleTextAttributes[.font] =  UIFont(name: "Knewave-Regular", size: 40)!
            navbarAppearance.largeTitleTextAttributes = largeTitleTextAttributes
            
            navbar.standardAppearance = navbarAppearance
        }
        #endif
    }
}
