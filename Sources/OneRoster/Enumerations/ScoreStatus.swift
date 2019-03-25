//
//  ScoreStatus.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// The set of permitted tokens for the type of score status.
///
/// The standard workflow is based upon the cycle of: not submitted -> submitted -> partially graded
/// -> fully graded.
public enum ScoreStatus: String, Codable {
    
    /// The result is exempt i.e. this score does NOT contribute to any summative assessment.
    case exempt
    
    /// The result is fully graded.
    case fullyGraded = "fully graded"
    
    /// The result is not submitted.
    case notSubmitted = "not submitted"
    
    /// The result is partially graded. Further scoring will be undertaken and this score must NOT be used in
    /// summative assessment i.e. it must become 'fully graded'.
    case partiallyGraded = "partially graded"
    
    /// The result is submitted. This is a FINAL score and can only be changed as part of a
    /// formal review process.
    case submitted
}
