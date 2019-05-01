//
//  DemographicData.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

/// Demographics information is taken from the Common Educational Data Standards from the US government. (http://ceds.ed.gov). Demographics are
/// OPTIONAL.
///
/// Note that demographics data is held in its own service, and that access to this service is considered privileged. Not all consumer keys will be
/// able to request demographics data.
///
/// Demographic Data is modeled in LIS, but the sort of demographic data required by K12 is very different to that modeled in LIS. For this reason,
/// new structures have been created.
///
/// The 'sourcedId' of the demographics MUST be the same as the 'sourcedId' of the user to which it refers.
public struct DemographicData: Codable, OneRosterBase {
    /// See `OneRosterBase.sourceId`
    public var sourcedId: String
    
    /// See `OneRosterBase.status`
    public var status: StatusType
    
    /// See `OneRosterBase.dateLastModified`
    public var dateLastModified: Date
    
    /// See `OneRosterBase.metadata`
    public var metadata: [String: String]?
    
    /// For example: 1908-04-01.
    public var birthDate: Date?
    
    /// See subsection 4.13.2 or `Gender` for the enumeration list.
    public var sex: Gender?
    
    /// Boolean ("true" | "false")
    public var americanIndianOrAlaskaNative: StringBoolean?
    
    /// Boolean ("true" | "false")
    public var asian: StringBoolean?
    
    /// Boolean ("true" | "false")
    public var blackOrAfricanAmerican: StringBoolean?
    
    /// Boolean ("true" | "false")
    public var nativeHawaiianOrOtherPacificIslander: StringBoolean?
    
    /// Boolean ("true" | "false")
    public var white: StringBoolean?
    
    /// Boolean ("true" | "false")
    public var demographicRaceTwoOrMoreRaces: StringBoolean?
    
    /// Boolean ("true" | "false")
    public var hispanicOrLatinoEthnicity: StringBoolean?
    
    /// Vocabulary - https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=20002
    public var countryOfBirthCode: String?
    
    /// Vocabulary - https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=20837
    public var stateOfBirthAbbreviation: StateCode?
    
    /// For example: Chicago
    public var cityOfBirth: String?
    
    /// Vocabulary - https://ceds.ed.gov/CEDSElementDetails.aspx?TermxTopicId=20863
    public var publicSchoolResidenceStatus: ResidenceStatus?

    /// Create new DemographicData
    public init(sourcedId: String,
                status: StatusType,
                dateLastModified: Date,
                metadata: [String: String]?,
                birthDate: Date?,
                sex: Gender?,
                americanIndianOrAlaskaNative: StringBoolean?,
                asian: StringBoolean?,
                blackOrAfricanAmerican: StringBoolean?,
                nativeHawaiianOrOtherPacificIslander: StringBoolean?,
                white: StringBoolean?,
                demographicRaceTwoOrMoreRaces: StringBoolean?,
                hispanicOrLatinoEthnicity: StringBoolean?,
                countryOfBirthCode: String?,
                stateOfBirthAbbreviation: StateCode?,
                cityOfBirth: String?,
                publicSchoolResidenceStatus: ResidenceStatus?)
    {
        self.sourcedId = sourcedId
        self.status = status
        self.dateLastModified = dateLastModified
        self.metadata = metadata
        self.birthDate = birthDate
        self.sex = sex
        self.americanIndianOrAlaskaNative = americanIndianOrAlaskaNative
        self.asian = asian
        self.blackOrAfricanAmerican = blackOrAfricanAmerican
        self.nativeHawaiianOrOtherPacificIslander = nativeHawaiianOrOtherPacificIslander
        self.white = white
        self.demographicRaceTwoOrMoreRaces = demographicRaceTwoOrMoreRaces
        self.hispanicOrLatinoEthnicity = hispanicOrLatinoEthnicity
        self.countryOfBirthCode = countryOfBirthCode
        self.stateOfBirthAbbreviation = stateOfBirthAbbreviation
        self.cityOfBirth = cityOfBirth
        self.publicSchoolResidenceStatus = publicSchoolResidenceStatus
    }
    
}
