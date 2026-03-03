//
//  DailyQuestions.swift
//  dumbphone
//
//  Created by Cynthia Lim on 2025-08-16.
//

import Foundation

// MARK: - Shared Types (mirrors main app's SharedStorage)

private struct Screenname: Codable {
    var id: UUID
    var handle: String
}

private func loadScreennames() -> [Screenname] {
    let defaults = UserDefaults(suiteName: "group.com.cynthialim.dumbphone")
    if let data = defaults?.data(forKey: "quoteScreennames"),
       let screennames = try? JSONDecoder().decode([Screenname].self, from: data) {
        return screennames
    }
    return [Screenname(id: UUID(), handle: "AlexHormozi")]
}

// MARK: - Twitter API Response Models

struct TimelineResponse: Decodable {
    let timeline: [Tweet]
    let next_cursor: String?
    let user: TimelineUser?
}

struct TimelineUser: Decodable {
    let name: String
}

struct Tweet: Decodable {
    let text: String
}

// MARK: - Cache Models

struct CachedTweet: Codable {
    let text: String
    let author: String
}

struct CachedQuotes: Codable {
    var quotes: [CachedTweet]
    let fetchedDate: Date
    var currentIndex: Int
    var nextCursor: String?
}

// MARK: - Quote Service

struct QuoteService {
    private static let defaults = UserDefaults(suiteName: "group.com.cynthialim.dumbphone")
    private static let cacheKey = "cachedHormoziQuotes"
    private static let fallback = CachedTweet(
        text: "Do the boring work that no one else is willing to do, and you'll never have to worry about money again.",
        author: "Alex Hormozi"
    )

    static func getDailyQuote() async -> CachedTweet {
        // Load cached quotes
        if var cached = loadCache() {
            let daysSinceFetch = Calendar.current.dateComponents(
                [.day], from: cached.fetchedDate, to: Date()
            ).day ?? 0
            let index = cached.currentIndex + daysSinceFetch

            if index < cached.quotes.count {
                cached.currentIndex = index
                saveCache(cached)
                return cached.quotes[index]
            }
        }

        // Cache exhausted or empty — fetch from all accounts and shuffle
        let handles = loadScreennames().map { $0.handle }
        if let quotes = await fetchAllTimelines(handles: handles) {
            let cached = CachedQuotes(
                quotes: quotes,
                fetchedDate: Date(),
                currentIndex: 0,
                nextCursor: nil
            )
            saveCache(cached)
            return quotes.first ?? fallback
        }

        // API failed — return last cached quote, else fallback
        if let cached = loadCache(), !cached.quotes.isEmpty {
            return cached.quotes[min(cached.currentIndex, cached.quotes.count - 1)]
        }

        return fallback
    }

    // MARK: - API Fetch

    private static func fetchAllTimelines(handles: [String]) async -> [CachedTweet]? {
        var allQuotes: [CachedTweet] = []

        await withTaskGroup(of: [CachedTweet].self) { group in
            for handle in handles {
                group.addTask { await fetchTimeline(screenname: handle) }
            }
            for await quotes in group {
                allQuotes.append(contentsOf: quotes)
            }
        }

        guard !allQuotes.isEmpty else { return nil }
        return allQuotes.shuffled()
    }

    private static func fetchTimeline(screenname: String) async -> [CachedTweet] {
        let urlString = "https://twitter-api45.p.rapidapi.com/timeline.php?screenname=\(screenname)"
        guard let url = URL(string: urlString) else { return [] }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(APIConfig.rapidAPIKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(APIConfig.rapidAPIHost, forHTTPHeaderField: "x-rapidapi-host")
        request.timeoutInterval = 15

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(TimelineResponse.self, from: data)
            let authorName = response.user?.name ?? screenname

            return response.timeline
                .map { $0.text }
                .filter { !$0.hasPrefix("RT @") && $0.count > 30 }
                .map { CachedTweet(text: $0, author: authorName) }
        } catch {
            print("QuoteService fetch error (\(screenname)): \(error)")
            return []
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
