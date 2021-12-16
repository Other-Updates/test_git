//
//  Extensions.swift
//  Runner
//
//  Created by iw on 25/06/21.
//

import Foundation

func decimal(with string: String) -> NSDecimalNumber {
    let formatter = NumberFormatter()
          formatter.minimumFractionDigits = 2
    return formatter.number(from: string) as? NSDecimalNumber ?? 0
}

func intFromHexString(hexStr: String) -> UInt32
{
    var hexInt: UInt32 = 0
    // Create scanner
    let scanner: Scanner = Scanner(string: hexStr)
    // Tell scanner to skip the # character
    scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
    // Scan hex value
    scanner.scanHexInt32(&hexInt)
    return hexInt
}

func HexToColor(hexString: String, alpha: CGFloat) -> UIColor
{
    // Convert hex string to an integer
    let hexint = Int(intFromHexString(hexStr: hexString))
    let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
    let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
    let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
    let alpha = alpha
    // Create color object, specifying alpha as well
    let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
    return color
}


