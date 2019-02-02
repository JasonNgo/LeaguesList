//
//  TeamsFactory.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-23.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

struct TeamsFactory {
    var teams: [Team]
    
    init() {
        teams = [
            Team(fullName: "Boston Bruins", name: "Bruins", location: "Boston", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/1/logo.png", colour1Hex: "FDB930", colour2Hex: "343434"),
            Team(fullName: "Buffalo Sabres", name: "Sabres", location: "Buffalo", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/2/logo.png", colour1Hex: "103662", colour2Hex: "FDB930"),
            Team(fullName: "Montreal Canadiens", name: "Canadiens", location: "Montreal", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/3/logo.png", colour1Hex: "B2222A", colour2Hex: "083A81"),
            Team(fullName: "Ottawa Senators", name: "Senators", location: "Ottawa", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/4/logo.png", colour1Hex: "E51837", colour2Hex: "D4A00F"),
            Team(fullName: "Toronto Maple Leafs", name: "Maple Leafs", location: "Toronto", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/5/logo.png", colour1Hex: "013E7F", colour2Hex: "343434"),
            Team(fullName: "New Jersey Devils", name: "Devils", location: "New Jersey", logoUrl:  "https://d12smlnp5321d2.cloudfront.net/hockey/team/6/logo.png", colour1Hex: "D02B2F", colour2Hex: "343434"),
            Team(fullName: "New York Islanders", name: "Islanders", location: "New York", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/7/logo.png", colour1Hex: "F57D31", colour2Hex: "00529B"),
            Team(fullName: "New York Rangers", name: "Rangers", location: "New York", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/8/logo.png", colour1Hex: "0161AB", colour2Hex: "0161AB"),
            Team(fullName: "Philadelphia Flyers", name: "Flyers", location: "Philadelphia", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/9/logo.png", colour1Hex: "E26327", colour2Hex: "343434"),
            Team(fullName: "Pittsburgh Penguins", name: "Penguins", location: "Pittsburgh", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/10/logo.png", colour1Hex: "C5B358", colour2Hex: "343434"),
            Team(fullName: "Winnipeg Jets", name: "Jets", location: "Winnipeg", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/11/logo.png", colour1Hex: "006EC8", colour2Hex: "006EC8"),
            Team(fullName: "Carolina Hurricanes", name: "Hurricanes", location: "Carolina", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/12/logo.png", colour1Hex:  "E51A38", colour2Hex: "343434"),
            Team(fullName: "Florida Panthers", name: "Panthers", location: "Florida", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/13/logo.png", colour1Hex: "C51230", colour2Hex: "002D62"),
            Team(fullName: "Tampa Bay Lightning", name: "Lightning", location: "Tampa Bay", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/14/logo.png", colour1Hex: "003D7C", colour2Hex: "343434"),
            Team(fullName: "Washington Capitals", name: "Capitals", location: "Washington", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/15/logo.png", colour1Hex: "C60C30", colour2Hex: "002147"),
            Team(fullName: "Chicago Blackhawks", name: "Blackhawks", location: "Chicago", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/16/logo.png", colour1Hex: "C60C30", colour2Hex: "E7AA21"),
            Team(fullName: "Columbus Blue Jackets", name: "Blue Jackets", location: "Columbus", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/17/logo.png", colour1Hex: "003168", colour2Hex: "C60C30"),
            Team(fullName: "Detroit Red Wings", name: "Red Wings", location: "Detroit", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/18/logo.png", colour1Hex: "E51837", colour2Hex: "343434"),
            Team(fullName: "Nashville Predators", name: "Predators", location: "Nashville", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/19/logo.png", colour1Hex: "FDBB30", colour2Hex: "002D62"),
            Team(fullName: "St. Louis Blues", name: "Blues", location: "St. Louis", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/20/logo.png", colour1Hex: "00529C", colour2Hex: "FDB930"),
            Team(fullName: "Anaheim Ducks", name: "Ducks", location: "Anaheim", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/21/logo.png", colour1Hex: "F57D31", colour2Hex: "B6985A"),
            Team(fullName: "Dallas Stars", name: "Stars", location: "Dallas", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/22/logo.png", colour1Hex: "016F4A", colour2Hex: "343434"),
            Team(fullName: "Los Angeles Kings", name: "Kings", location: "Los Angeles", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/23/logo.png", colour1Hex: "343434", colour2Hex: "343434"),
            Team(fullName: "Arizona Coyotes", name: "Coyotes", location: "Arizona", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/24/logo.png", colour1Hex: "98012E", colour2Hex: "CDB994"),
            Team(fullName: "San Jose Sharks", name: "Sharks", location: "San Jose", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/25/logo.png", colour1Hex: "007889", colour2Hex: "F4901E"),
            Team(fullName: "Calgary Flames", name: "Flames", location: "Calgary", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/26/logo.png", colour1Hex: "D1343A", colour2Hex: "FDBF12"),
            Team(fullName: "Colorado Avalanche", name: "Avalanche", location: "Colorado", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/27/logo.png", colour1Hex: "822433", colour2Hex: "165788"),
            Team(fullName: "Edmonton Oilers", name: "Oilers", location: "Edmonton", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/28/logo.png", colour1Hex: "EB6E1E", colour2Hex: "013E7F"),
            Team(fullName: "Minnesota Wild", name: "Wild", location: "Minnesota", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/29/logo.png", colour1Hex: "004F30", colour2Hex: "C51230"),
            Team(fullName: "Vancouver Canucks", name: "Canucks", location: "Vancouver", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/30/logo.png", colour1Hex: "003E7E", colour2Hex: "008852"),
            Team(fullName: "Atlantic All-Stars", name: "All-Stars", location: "Team Atlantic", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/31/logo.png", colour1Hex: nil, colour2Hex: nil),
            Team(fullName: "Central All-Stars", name: "All-Stars", location: "Team Central", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/32/logo.png", colour1Hex: nil, colour2Hex: nil),
            Team(fullName: "Metropolitan All-Stars", name: "All-Stars", location: "Metropolitan", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/67/logo.png", colour1Hex: nil, colour2Hex: nil),
            Team(fullName: "Pacific All-Stars", name: "All-Stars", location: "Pacific", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/68/logo.png", colour1Hex: nil, colour2Hex: nil),
            Team(fullName: "Vegas Golden Knights", name: "Golden Knights", location: "Vegas", logoUrl: "https://d12smlnp5321d2.cloudfront.net/hockey/team/102/logo.png", colour1Hex: "87704E", colour2Hex:  "334049")
        ]
        
        teams.sort { $0.fullName < $1.fullName }
    }
}
