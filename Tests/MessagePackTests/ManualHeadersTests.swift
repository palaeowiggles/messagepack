/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import Test
import MessagePack

class ManualHeadersTests: TestCase {
    func testEncodeArray() {
        let expected = MessagePack.encode(.array(["one", "two", "three"]))
        var encoder = Encoder()
        let items = ["one", "two", "three"]
        encoder.encodeArrayItemsCount(items.count)
        for item in items {
            encoder.encode(item)
        }
        assertEqual(encoder.bytes, expected)
    }

    func testDecodeArray() {
        let expected = ["one", "two", "three"]
        let encoded = MessagePack.encode(.array(["one", "two", "three"]))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        var result = [String]()
        do {
            let itemsCount = try decoder.decodeArrayItemsCount()
            for _ in 0..<itemsCount {
                result.append(try decoder.decode(String.self))
            }
        } catch {
            fail(String(describing: error))
            return
        }
        assertEqual(result, expected)
    }

    func testEncodeMap() {
        let expected = MessagePack.encode(
            .map(["one" : 1, "two" : 2, "three" : 3]))
        var encoder = Encoder()
        let items = ["one" : 1, "two" : 2, "three" : 3]
        encoder.encodeMapItemsCount(items.count)
        for (key, value) in items {
            encoder.encode(key)
            encoder.encode(value)
        }
        assertEqual(encoder.bytes, expected)
    }

    func testDecodeMap() {
        let expected = ["one" : 1, "two" : 2, "three" : 3]
        let encoded = MessagePack.encode(
            .map(["one" : 1, "two" : 2, "three" : 3]))
        var decoder = Decoder(bytes: encoded, count: encoded.count)
        var result = [String : Int]()
        do {
            let itemsCount = try decoder.decodeMapItemsCount()
            for _ in 0..<itemsCount {
                let key = try decoder.decode(String.self)
                let value = try decoder.decode(Int.self)
                result[key] = value
            }
        } catch {
            fail(String(describing: error))
            return
        }
        assertEqual(result, expected)
    }


    static var allTests = [
        ("testEncodeArray", testEncodeArray),
        ("testDecodeArray", testDecodeArray),
        ("testEncodeMap", testEncodeMap),
        ("testDecodeMap", testDecodeMap)
    ]
}