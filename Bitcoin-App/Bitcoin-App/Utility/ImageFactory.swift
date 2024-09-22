//
//  ImageFactory.swift
//  Bitcoin-App
//
//  Created by Joshua Coetzer on 2024/09/21.
//

import Foundation
import UIKit

/// A factory for providing system images related to trends and other visual indicators.
///
/// This struct contains static properties that return `UIImage` instances for various
/// trend indicators and symbols used within the application. The images are loaded using
/// the system's SF Symbols.
///
/// - Note: All images are represented as static constants, allowing easy access without
///   the need to instantiate the `ImageFactory`.
struct ImageFactory {
    static let uptrendImage = UIImage(systemName: "chart.line.uptrend.xyaxis")
    static let downtrendImage = UIImage(systemName: "chart.line.downtrend.xyaxis")
    static let flattrendImage = UIImage(systemName: "chart.line.flattrend.xyaxis")
    static let linesImage = UIImage(systemName: "line.horizontal.3")
    static let starImage = UIImage(systemName: "star")
}
