//
//  NetworkStatus.swift
//  QCSM4
//
//  Created by Yasir Basharat on 15/04/2019.
//  Copyright © 2019 Yasir Basharat. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

protocol NetWorkStatusChangeable {

	func isNetworkAvailable() -> Bool
	func isWifi() -> Bool
	func isCellular() -> Bool
	func unknown() -> Bool
}
#if canImport(Network)
import Network
@available(iOS 12.0, *)
class NetworkStatus {

	private var pathMonitor: NWPathMonitor!
	private var pathUpdateHandler: ((NWPath) -> Void) = { path in

		if path.status == NWPath.Status.satisfied {
			SharedLogger.logInfo("Connected")
		} else if path.status == NWPath.Status.unsatisfied {
			SharedLogger.logInfo("unsatisfied")
		} else if path.status == NWPath.Status.requiresConnection {
			SharedLogger.logInfo("requiresConnection")
		}
	}

	private let backgroudQueue = DispatchQueue.global(qos: .background)
	static let shared = NetworkStatus()

	private init() {
		pathMonitor = NWPathMonitor()
		pathMonitor.pathUpdateHandler = pathUpdateHandler
		pathMonitor.start(queue: backgroudQueue)
	}
}

@available(iOS 12.0, *)
extension NetworkStatus: NetWorkStatusChangeable {

	func isNetworkAvailable() -> Bool {
		return pathMonitor.currentPath.status == NWPath.Status.satisfied
	}

	func isWifi() -> Bool {
		return pathMonitor.currentPath.usesInterfaceType(.wifi)
	}

	func isCellular() -> Bool {
		return pathMonitor.currentPath.usesInterfaceType(.cellular)
	}
	private func isWiredEthernet() -> Bool {
		return pathMonitor.currentPath.usesInterfaceType(.wiredEthernet)
	}

	func unknown() -> Bool {
		return pathMonitor.currentPath.usesInterfaceType(.other)
	}
}
#endif

class ReachabilityStatus {

	static let shared = ReachabilityStatus()

	private let reachability = Reachability()!

	private init() {
		startNotifier()
	}

	private func setReachabilityNotifier () {

		_ = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { [weak self] (_) in
			self?.stopNotifier()
		}

		_ = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { [weak self] (_) in
			self?.startNotifier()
		}

		NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
		do {
			try reachability.startNotifier()
		} catch {
			SharedLogger.logInfo("could not start reachability notifier\(error.localizedDescription)")
		}
	}

	public func startNotifier() {
		setReachabilityNotifier()
	}

	public func stopNotifier() {
		reachability.stopNotifier()
		NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
	}

	deinit {
		stopNotifier()
	}

	@objc private func reachabilityChanged(note: Notification) {

		let reachability = note.object as! Reachability

		switch reachability.connection {
		case .wifi:
			SharedLogger.logInfo("Reachable via WiFi")
		case .cellular:
			SharedLogger.logInfo("Reachable via Cellular")
		case .none:
			SharedLogger.logInfo("Network not reachable")
		}
	}
}
extension ReachabilityStatus: NetWorkStatusChangeable {

	func isNetworkAvailable() -> Bool {
		return reachability.connection != .none
	}
	func isWifi() -> Bool {
		return reachability.connection == .wifi
	}
	func isCellular() -> Bool {
		return reachability.connection == .cellular
	}
	func unknown() -> Bool {
		return reachability.connection == .none
	}
}
