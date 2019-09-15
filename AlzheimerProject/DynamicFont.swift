//
//  DynamicFont.swift
//  AlzheimerProject
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 14/09/19.
//  Copyright © 2019 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import Foundation
import UIKit


public final class ScaledFont {
    
    private struct FontDescription: Decodable {
        let fontSize: CGFloat
        let fontName: String
    }
    
    private typealias StyleDictionary = [UIFont.TextStyle.RawValue: FontDescription]
    private var styleDictionary: StyleDictionary?
    
    public init(fontName: String) {
        if let url = Bundle.main.url(forResource: fontName, withExtension: "plist"),
            let data = try? Data(contentsOf: url) {
            let decoder = PropertyListDecoder()
            styleDictionary = try? decoder.decode(StyleDictionary.self, from: data)
        }
    }
    
    public func font(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        guard let fontDescription = styleDictionary?[textStyle.rawValue],
            let font = UIFont(name: fontDescription.fontName, size: fontDescription.fontSize) else {
                return UIFont.preferredFont(forTextStyle: textStyle)
        }
        
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        
        return fontMetrics.scaledFont(for: font)
    }
}
