//
//  PrivacyPolicy.swift
//  Inner
//
//  Created by Karina Kazbekova on 30.09.2026.
//


import Foundation

enum PrivacyPolicy {
    static let healthDataStoredLocally = true
    static let healthDataSentExternally = false
    static let healthDataLogged = false
    static let notesLogged = false
    static let analyticsUsesHealthDataExternally = false
}