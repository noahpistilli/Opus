//
//  OpusError.swift
//  
//
//  Created by Noah Pistilli on 2022-05-13.
//

import Foundation

public enum OpusError: Error {
    case encoderCreationFailure
    case convertingToUnsafePointerFailure
}
