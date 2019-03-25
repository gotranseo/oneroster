//
//  SubjectCode.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// This is a machine readable set of codes and the number should match the associated 'subjects' attribute.
///
/// The vocabulary is from SCED (School Codes for the Exchange of Data Version 4):
/// http://nces.ed.gov/forum/SCED.asp.
public enum SubjectCode: String, Codable {
    #warning("FIX")
    case test
}
