//
//  DataService.swift
//  RemoteConfigurationDemo
//
//  Created by Pinto Diaz, Roger on 11/3/20.
//

import Foundation
import FirebaseStorage

final class DataService {

    // MARK: - Properties
    static let instance = DataService()

    private var _REF_STORAGE = Storage.storage().reference()

    private var REF_STORAGE: StorageReference {
        _REF_STORAGE
    }

    private let childID = ""

    func setRemoteData(_ data: Data) {
        let reference = REF_STORAGE.child(childID)
        reference.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error)
            } else {
                reference.downloadURL(completion: { (url, error) in
                    print("Remote url: \(url)")
                })
            }
        }
    }

    func getRemoteData(onCompletion: @escaping (Data) -> Void) {
        REF_STORAGE.child(childID).getData(maxSize: 5000) { (data, error) in
            if let data = data {
                onCompletion(data)
            }
        }
    }
}
