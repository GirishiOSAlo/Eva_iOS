//
//  SharedLogger.swift
//  QCSM4
//
//  Created by Yasir Basharat on 25/02/2019.
//  Copyright © 2019 Yasir Basharat. All rights reserved.
//

import Foundation

public final class SharedLogger {

	static private(set) var privateQueue = DispatchQueue(label: "com.qcs.loggingQueue")

	/// Logging Error Message to console
	///
	/// - Parameter message: String
	public static func logError(_ message: String) {
		if !SharedLogger.isLogEnabled() {
			return
		}
		privateQueue.async {
			print("*********** Error *********** : \(message)")
		}
	}
	/// Logging Info to console
	///
	/// - Parameter message: String
	public static func logInfo(_ message: String) {
		if !SharedLogger.isLogEnabled() {
			return
		}
		privateQueue.async {
			print(message)
		}
	}
	//This method is used to enabled and disabled log when releasing the app for test or apple store
	public static func isLogEnabled() -> Bool {
		#if DEBUG
		return true
		#else
		return false
		#endif
	}
	/// Loging Error
	///
	/// - Parameter error: Error
	public static func logException(_ error: Error) {
		privateQueue.async {
		 print((error as NSError).localizedDescription)
		}
	}
}
