//
//  InventoryDemoTests.swift
//  InventoryDemoTests
//
//  Created by Diego Freniche on 21/04/2021.
//

import XCTest
import RealmSwift
@testable import InventoryDemo

class InventoryDemoTests: XCTestCase {

    // get in-memory Realm
    let realm: Realm? = RealmUtil.initRealm()

    func testRealmInitCorrectly() throws {
        // Given a Realm

        // Then it should not be nil
        XCTAssertNotNil(realm)
    }
    
    func testSampleInventoryItemIsCorrect() throws {
        // Given a Realm

        // When we insert a new Item
        let item = InventoryItem.sample
        
        // Then it should have the correct data in it
        XCTAssertNotNil(item)
        XCTAssertEqual(9.99,        item.price)
        XCTAssertEqual("Widget",    item.name)
        XCTAssertEqual(66,          item.quantity)
    }
    
    func testCanSaveInventoryItem() {
        // Given a Realm and an InventoryItem
        let item = InventoryItem("some item")
        item.price = 10
        
        // When we insert a new Item
        do {
            try realm?.write {
                realm?.add(item)
            }
        } catch {
            // Then it shouldn't fail inserting
            XCTFail("Error writing: \(error)")
        }
    }
    
    func testCanDeleteAllInventoryItems() {
        // Given we can have items in the Realm
        
        // When we delete all items
        deleteAllInventoryItems()
        
        // Then no items should be left
        let allInventoryItems = realm?.objects(InventoryItem.self)
        
        XCTAssertEqual(allInventoryItems?.count, 0)
    }
    
    func testCanReadInventoryItems() {
        // Given we can have items in the Realm
        
        // When we delete all items and insert 10 new items
        deleteAllInventoryItems()
        insertInventoryItems(10)
        
        // Then we should have exactly 10 items left
        let allInventoryItems = realm?.objects(InventoryItem.self)
        
        XCTAssertEqual(allInventoryItems?.count, 10)
    }
    
    // MARK: - Testing Utilities
    
    // inserts n Inventory Items
    private func insertInventoryItems(_ n: Int) {
        for i in 1...n {
            insertInventoryItem(named: "Inventory item \(i)")
        }
    }
    
    // inserts just one Inventory Object
    private func insertInventoryItem(named: String) {
        let item = InventoryItem(named)
        
        do {
            try realm?.write {
                realm?.add(item)
            }
        } catch {
            XCTFail("Error writing: \(error)")
        }
    }
    
    // deletes all Inventory Items
    private func deleteAllInventoryItems() {
        let allInventoryItems = realm?.objects(InventoryItem.self)
        try! realm?.write {
            realm?.delete(allInventoryItems!)
        }
    }
}
