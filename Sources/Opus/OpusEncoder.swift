//
//  OpusEncoder.swift
//  
//
//  Created by Noah Pistilli on 2022-05-13.
//

import Foundation
import ConfigureCoder
import COPUS

public class OpusEncoder {
    
    // MARK: Properties
    
    /// The bitrate for this encoder.
    public let bitrate: Int

    /// The number of channels.
    public let channels: Int

    /// The sampling rate.
    public let sampleRate: Int

    /// The state of the encoder
    let encoderState: OpaquePointer
    
    public init(sampleRate: Int, channels: Int, bitrate: Int) throws {
        self.bitrate = bitrate
        self.channels = channels
        self.sampleRate = sampleRate
        
        var err = 0 as Int32
        self.encoderState = opus_encoder_create(Int32(sampleRate), Int32(channels), OPUS_APPLICATION_AUDIO, &err)
        
        err = configure_encoder(encoderState, Int32(bitrate), 0)
        
        guard err == 0 else {
            opus_encoder_destroy(self.encoderState)
            throw OpusError.encoderCreationFailure
        }
    }
}

extension OpusEncoder {
    
    ///
    /// Encodes passed data into Opus encoded audio
    ///
    /// - parameter data: A `Data` object with Opus supported audio
    /// - returns: A `Data` object with Opus encoded bytes.
    ///
    public func encode(_ data: Data) throws -> Data {
        var input: UnsafePointer<opus_int16>?
        
        data.withUnsafeBytes { unsafeBytes in
            input = unsafeBytes.bindMemory(to: opus_int16.self).baseAddress
        }
        
        if let input = input {
            return Data(self.encode(input))
        } else {
            throw OpusError.convertingToUnsafePointerFailure
        }
    }
    
    ///
    /// Encodes passed data into Opus encoded audio
    ///
    /// - parameter data: A `Data` object with Opus supported audio
    /// - returns: A byte array with Opus encoded bytes.
    ///
    public func encode(_ data: Data) throws -> [UInt8] {
        var input: UnsafePointer<opus_int16>?
        
        data.withUnsafeBytes { unsafeBytes in
            input = unsafeBytes.bindMemory(to: opus_int16.self).baseAddress
        }
        
        if let input = input {
            return self.encode(input)
        } else {
            throw OpusError.convertingToUnsafePointerFailure
        }
    }
    
    ///
    /// Encodes passed data into Opus encoded audio
    ///
    /// - parameter data: A byte array with Opus supported audio
    /// - returns: A `Data` object with Opus encoded bytes.
    ///
    public func encode(_ data: [UInt8]) throws -> Data {
        var input: UnsafePointer<opus_int16>?
        
        data.withUnsafeBytes { unsafeBytes in
            input = unsafeBytes.bindMemory(to: opus_int16.self).baseAddress
        }
        
        if let input = input {
            return Data(self.encode(input))
        } else {
            throw OpusError.convertingToUnsafePointerFailure
        }
    }
    
    ///
    /// Encodes passed data into Opus encoded audio
    ///
    /// - parameter data: A byte array with Opus supported audio
    /// - returns: A byte array with Opus encoded bytes.
    ///
    public func encode(_ data: [UInt8]) throws -> [UInt8] {
        var input: UnsafePointer<opus_int16>?
        
        data.withUnsafeBytes { unsafeBytes in
            input = unsafeBytes.bindMemory(to: opus_int16.self).baseAddress
        }
        
        if let input = input {
            return self.encode(input)
        } else {
            throw OpusError.convertingToUnsafePointerFailure
        }
    }
    
    ///
    /// Actually encodes passed data into Opus encoded audio.
    /// This is the function that calls the `opus_encode` function.
    /// The others call this as this needs a lower level data type.
    ///
    /// - parameter audio: A pointer to the audio data.
    /// - returns: An opus encoded packet.
    ///
    private func encode(_ audio: UnsafePointer<opus_int16>) -> [UInt8] {
        let output = UnsafeMutablePointer<UInt8>.allocate(capacity: 3840)
        let lenPacket = opus_encode(self.encoderState, audio, Int32(960), output, opus_int32(3840))
        
        defer { output.deallocate() }

        return Array(UnsafeBufferPointer(start: output, count: Int(lenPacket)))
    }
}
