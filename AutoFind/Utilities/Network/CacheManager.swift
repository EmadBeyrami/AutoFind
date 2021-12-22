//
//  CacheManager.swift
//  AutoFind
//
//  Created by Emad Bayramy on 12/22/21.
//

import Foundation

class AutoFindCacheManager {
    
    // MARK: - singleton
    static let standard = AutoFindCacheManager(cacheManager: URLCache.shared)
    
    // MARK: - Initializer
    var cacheManager: URLCache
    init(cacheManager: URLCache) {
        self.cacheManager = cacheManager
    }
    
    func cachedResponse(for urlRequest: URLRequest) -> CachedURLResponse? {
        cacheDesciption()
        return cacheManager.cachedResponse(for: urlRequest)
    }
    
    internal func cacheConfig() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadRevalidatingCacheData
        config.urlCache?.memoryCapacity = 256 * 1024 * 1024
        return config
    }
    
    func clearAllCache() {
        cacheManager.removeAllCachedResponses()
        print("🔴 Removed All Cached Response 🔴")
    }
    
    private func cacheDesciption() {
        print("💾 Disk usage/capacity: \(cacheManager.currentDiskUsage)/\(cacheManager.diskCapacity), 💾 memory usage/capacity: \(cacheManager.currentMemoryUsage)/\(cacheManager.memoryCapacity) 💾")
    }
}

// MARK: - CacheManagable
extension AutoFindCacheManager: CacheManagable { }
