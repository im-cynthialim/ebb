//
//  AppInfo.swift
//  dumbphone
//
//  Created by Cynthia Lim on 2024-11-25.
//

import Foundation

struct AppInfo: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var urlScheme: String
  
    // Custom initializer to make sure `id` is generated only if it's missing.
      init(id: UUID = UUID(), name: String, urlScheme: String) {
      self.id = id
      self.name = name
      self.urlScheme = urlScheme
  }
}



let availableApps: [AppInfo] =
  [
    AppInfo(name: "Apple News", urlScheme: "applenews://"),
    AppInfo(name: "App Store", urlScheme: "itms-apps://itunes.apple.com"),
    AppInfo(name: "Apple Music", urlScheme: "music://"),
    AppInfo(name: "Apple Music Classical", urlScheme: "classical://"),
    AppInfo(name: "Apple TV", urlScheme: "videos://"),
    AppInfo(name: "Calendar", urlScheme: "calshow://"),
    AppInfo(name: "Clips", urlScheme: "clips://"),
    AppInfo(name: "Contacts", urlScheme: "contacts://"),
    AppInfo(name: "Diagnostics", urlScheme: "diags://"),
    AppInfo(name: "FaceTime (Video)", urlScheme: "facetime://"),
    AppInfo(name: "Feedback", urlScheme: "applefeedback://"),
    AppInfo(name: "Find My Friends", urlScheme: "fmf1://"),
    AppInfo(name: "Find My iPhone", urlScheme: "fmip1://"),
    AppInfo(name: "Files", urlScheme: "shareddocuments://"),
    AppInfo(name: "Game Center", urlScheme: "gamecenter://"),
    AppInfo(name: "GarageBand", urlScheme: "garageband://"),
    AppInfo(name: "Headspace", urlScheme: "headspace://"),
    AppInfo(name: "iBooks", urlScheme: "ibooks://"),
    AppInfo(name: "iCloud Drive", urlScheme: "appleiclouddrive://"),
    AppInfo(name: "iMovie", urlScheme: "imovie://"),
    AppInfo(name: "iTunes Remote", urlScheme: "remote://"),
    AppInfo(name: "iTunes Store", urlScheme: "itms://"),
    AppInfo(name: "iTunes U", urlScheme: "itms-itunesu://"),
    AppInfo(name: "Maps", urlScheme: "map://"),
    AppInfo(name: "Mail", urlScheme: "message://"),
    AppInfo(name: "Messages", urlScheme: "sms://"),
    AppInfo(name: "Notes", urlScheme: "mobilenotes://"),
    AppInfo(name: "Phone", urlScheme: "tel://"),
    AppInfo(name: "Photos", urlScheme: "photos-redirect://"),
    AppInfo(name: "Podcasts (Browse)", urlScheme: "pcast://"),
    AppInfo(name: "Reminders", urlScheme: "x-apple-reminder://"),
    AppInfo(name: "Safari (Search)", urlScheme: "x-web-search://"),
    AppInfo(name: "Settings", urlScheme: "App-prefs://"),
    AppInfo(name: "Shortcuts", urlScheme: "shortcuts://"),
    AppInfo(name: "Voice Memos", urlScheme: "voicememos://"),
    AppInfo(name: "Wallet", urlScheme: "shoebox://"),
    AppInfo(name: "Watch", urlScheme: "itms-watch://"),
    AppInfo(name: "Workflow", urlScheme: "workflow://"),
    //
    //  AppInfo(name: "1Password", urlScheme: "onepassword://search/{query}"),
    //  AppInfo(name: "1Password Browser", urlScheme: "ophttp://{url}"),
    AppInfo(name: "Achievement - Reward Health", urlScheme: "achievement://"),
    AppInfo(name: "Age of Solitaire : Build City", urlScheme: "fb1431194636974533://"),
    AppInfo(name: "AMC Theatres", urlScheme: "amc://"),
    AppInfo(name: "Alpha Omega", urlScheme: "fb1414385748867269suffix://"),
    AppInfo(name: "AmpliFi WiFi", urlScheme: "fb1761190244145574amplifi://"),
    AppInfo(name: "Ancestry", urlScheme: "ancestry://"),
    AppInfo(name: "Anchor", urlScheme: "anchorfm://"),
    AppInfo(name: "Bambu Handy", urlScheme: "bambulab://"),
    AppInfo(name: "Bejeweled Blitz", urlScheme: "com.popcap.ios.BejBlitz://"),
    AppInfo(name: "Blind", urlScheme: "teamblind://"),
    AppInfo(name: "Bloomberg", urlScheme: "bloomberg://"),
    AppInfo(name: "Brushstroke", urlScheme: "brushstroke://"),
    AppInfo(name: "Cake Browser", urlScheme: "cakeslice://"),
    AppInfo(name: "Camera+", urlScheme: "cameraplus://"),
    AppInfo(name: "Cash App", urlScheme: "squarecash://"),
    AppInfo(name: "Castro", urlScheme: "castro2://"),
    //  AppInfo(name: "CityMapper", urlScheme: "citymapper://directions?startcoord=<lat>,<lon>&startname=<name>&startaddress=<address>&endcoord=<lat>,<lon>&endname=<name>&endaddress=<address>"),
    AppInfo(name: "Clash of Clans", urlScheme: "clashofclans://"),
    AppInfo(name: "DoorDash - Food Delivery", urlScheme: "doordash://"),
    AppInfo(name: "Draw Something", urlScheme: "fb225826214141508paid://"),
    AppInfo(name: "Dropbox", urlScheme: "dbapi-1://"),
    AppInfo(name: "DuckDuckGo Privacy Browser", urlScheme: "ddgLaunch://"),
    AppInfo(name: "Duolingo", urlScheme: "duolingo://"),
    //  AppInfo(name: "Evernote", urlScheme: "evernote://x-callback-url/[action]?[action parameters]&[x-callback parameters]"),
    AppInfo(name: "Eufy Security", urlScheme: "eufysecurity://"),
    AppInfo(name: "Facebook", urlScheme: "fb://"),
    AppInfo(name: "Facetune", urlScheme: "facetune://"),
    AppInfo(name: "Fandango", urlScheme: "fandango://"),
    AppInfo(name: "Fantastical", urlScheme: "fantastical://"),
    AppInfo(name: "Fitbit", urlScheme: "fitbit://"),
    AppInfo(name: "Flickr", urlScheme: "flickr://"),
    AppInfo(name: "Forest", urlScheme: "forest://"),
    AppInfo(name: "Gboard", urlScheme: "gboard://"),
    AppInfo(name: "Genshin Impact", urlScheme: "yuanshengame://"),
    AppInfo(name: "GitHub", urlScheme: "github://"),
    AppInfo(name: "Gmail - Email by Google", urlScheme: "googlegmail://"),
    AppInfo(name: "Goodreads", urlScheme: "goodreads://"),
    AppInfo(name: "Google", urlScheme: "google://"),
    AppInfo(name: "Google Assistant", urlScheme: "googleassistant://"),
    AppInfo(name: "Google Calendar", urlScheme: "googlecalendar://"),
    AppInfo(name: "Google Docs", urlScheme: "googledocs://"),
    AppInfo(name: "Google Chrome", urlScheme: "googlechrome://"),
    AppInfo(name: "Google Drive", urlScheme: "googledrive://"),
    AppInfo(name: "Google Earth", urlScheme: "googleearth://"),
    AppInfo(name: "Google Keep", urlScheme: "comgooglekeep://"),
    AppInfo(name: "Google Maps - GPS Navigation", urlScheme: "googlemaps://"),
    AppInfo(name: "Google Photos", urlScheme: "googlephotos://"),
    AppInfo(name: "Google Sheets", urlScheme: "googlesheets://"),
    AppInfo(name: "Google Translate", urlScheme: "googletranslate://"),
    AppInfo(name: "Google Voice", urlScheme: "googlevoice://"),
    AppInfo(name: "Halide Camera", urlScheme: "halide://"),
    AppInfo(name: "HBO GO", urlScheme: "hbogo://"),
    AppInfo(name: "HBO NOW", urlScheme: "hbonow://"),
    AppInfo(name: "Hulu", urlScheme: "hulu://"),
    AppInfo(name: "IFTTT", urlScheme: "ifttt://"),
    AppInfo(name: "IMDb Movies & TV", urlScheme: "imdb://"),
    AppInfo(name: "Instagram", urlScheme: "instagram://"),
    AppInfo(name: "Instapaper", urlScheme: "instapaper://"),
    AppInfo(name: "LastPass Password Manager", urlScheme: "lastpass://"),
    AppInfo(name: "LinkedIn", urlScheme: "linkedin://"),
    AppInfo(name: "Netflix", urlScheme: "nflx://"),
    AppInfo(name: "Spotify Music", urlScheme: "spotify://"),
    AppInfo(name: "Twitch", urlScheme: "twitch://"),
    AppInfo(name: "Twitter", urlScheme: "twitter://"),
    AppInfo(name: "WhatsApp Messenger", urlScheme: "whatsapp://"),
    AppInfo(name: "YouTube: Watch, Listen, Stream", urlScheme: "youtube://")
  ]
  
