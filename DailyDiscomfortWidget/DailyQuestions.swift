//
//  DailyQuestions.swift
//  dumbphone
//
//  Created by Cynthia Lim on 2025-08-16.
//

import Foundation

// MARK: - Cached Quotes Model

struct CachedQuotes: Codable {
    var quotes: [String]
    let fetchedDate: Date
    var currentIndex: Int
    var nextCursor: String?
}

// MARK: - Twitter API Response Models

struct TimelineResponse: Codable {
    let timeline: [Tweet]
    let next_cursor: String?
}

struct Tweet: Codable {
    let text: String
}

// MARK: - Quote Service

struct HormoziQuoteService {
    private static let defaults = UserDefaults(suiteName: "group.com.cynthialim.dumbphone")
    private static let cacheKey = "cachedHormoziQuotes"
    private static let fallbackQuote = "Do the boring work that no one else is willing to do, and you'll never have to worry about money again."

    static func getDailyQuote() async -> String {
        // Load cached quotes
        if var cached = loadCache() {
            let daysSinceFetch = Calendar.current.dateComponents(
                [.day], from: cached.fetchedDate, to: Date()
            ).day ?? 0
            let index = cached.currentIndex + daysSinceFetch

            if index < cached.quotes.count {
                // Still have quotes left — update index and return
                cached.currentIndex = index
                saveCache(cached)
                return cached.quotes[index]
            }
        }

        // Cache exhausted or empty — fetch more tweets
        let cursor = loadCache()?.nextCursor
        if let result = await fetchTimeline(cursor: cursor) {
            let cached = CachedQuotes(
                quotes: result.quotes,
                fetchedDate: Date(),
                currentIndex: 0,
                nextCursor: result.nextCursor
            )
            saveCache(cached)
            return result.quotes.first ?? fallbackQuote
        }

        // API failed — try returning any remaining cached quote, else fallback
        if let cached = loadCache(), !cached.quotes.isEmpty {
            let index = min(cached.currentIndex, cached.quotes.count - 1)
            return cached.quotes[index]
        }

        return fallbackQuote
    }

    // MARK: - API Fetch

    private static func fetchTimeline(cursor: String? = nil) async -> (quotes: [String], nextCursor: String?)? {
        var urlString = "https://twitter-api45.p.rapidapi.com/timeline.php?screenname=\(APIConfig.screenName)"
        if let cursor = cursor {
            urlString += "&cursor=\(cursor)"
        }

        guard let url = URL(string: urlString) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(APIConfig.rapidAPIKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(APIConfig.rapidAPIHost, forHTTPHeaderField: "x-rapidapi-host")
        request.timeoutInterval = 15

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(TimelineResponse.self, from: data)

            let quotes = response.timeline
                .map { $0.text }
                .filter { text in
                    // Filter out retweets and very short tweets
                    !text.hasPrefix("RT @") && text.count > 30
                }

            return quotes.isEmpty ? nil : (quotes, response.next_cursor)
        } catch {
            print("HormoziQuoteService fetch error: \(error)")
            return nil
        }
    }

    // MARK: - Cache

    private static func loadCache() -> CachedQuotes? {
        guard let data = defaults?.data(forKey: cacheKey) else { return nil }
        return try? JSONDecoder().decode(CachedQuotes.self, from: data)
    }

    private static func saveCache(_ cache: CachedQuotes) {
        if let data = try? JSONEncoder().encode(cache) {
            defaults?.set(data, forKey: cacheKey)
        }
    }
}
