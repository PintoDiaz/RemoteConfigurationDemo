//
//  Structs.swift
//  RemoteConfigurationDemo
//
//  Created by Pinto Diaz, Roger on 11/4/20.
//

import UIKit

struct RemoteView: Codable {
    let data: Data
    let relationships: [Relationship]
}

struct Relationship: Codable {
    let child: Int
    let parent: Int
    let constraints: Constraints
    let imageUrl: String?
    let hasShadow: Bool
}

struct Constraints: Codable {
    let top: CGFloat
    let bottom: CGFloat
    let left: CGFloat
    let right: CGFloat
}
