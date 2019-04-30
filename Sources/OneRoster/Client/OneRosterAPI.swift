//
//  OneRosterAPI.swift
//  OneRoster
//
//  Copyright Slate Solutions, Inc 2019.
//

import Foundation

public struct OneRosterAPI {
    public enum Endpoint {
        /// Return collection of demographics.
        case getAllDemographics
        
        /// Return specific demographics.
        case getDemographics(id: String)
        
        /// Return collection of all enrollments.
        case getAllEnrollments
        
        /// Return specific enrollment.
        case getEnrollment(id: String)
        
        /// Return collection of Orgs.
        case getAllOrgs
        
        /// Return Specific Org.
        case getOrg(id: String)
        
        /// Return collection of schools. A School is an instance of an Org.
        case getAllSchools
        
        /// Return specific school. A School is an instance of an Org.
        case getSchool(id: String)
        
        /// Return collection of students. A Student is an instance of a User.
        case getAllStudents
        
        /// Return specific student. A Student is an instance of a User.
        case getStudent(id: String)
        
        /// Return collection of teachers. A Teacher is an instance of a User.
        case getAllTeachers
        
        /// Return specific teacher.
        case getTeacher(id: String)
        
        /// Return collection of users
        case getAllUsers
        
        /// Return specific user
        case getUser(id: String)
        
        /// Return the collection of students attending this school.
        case getStudentsForSchool(id: String)
        
        /// Return the collection of teachers teaching at this school.
        case getTeachersForSchool(id: String)
        
        public var endpoint: String {
            switch self {
                case .getAllDemographics: return "/demographics"
                case .getDemographics(let id): return "/demographics/\(id)"
                case .getAllEnrollments: return "/enrollments"
                case .getEnrollment(let id): return "/enrollments/\(id)"
                case .getAllOrgs: return "/orgs"
                case .getOrg(let id): return "/orgs/\(id)"
                case .getAllSchools: return "/schools"
                case .getSchool(let id): return "/schools/\(id)"
                case .getAllStudents: return "/students"
                case .getStudent(let id): return "/students/\(id)"
                case .getAllTeachers: return "/teachers"
                case .getTeacher(let id): return "/teachers/\(id)"
                case .getAllUsers: return "/users"
                case .getUser(let id): return "/users/\(id)"
                case .getStudentsForSchool(let id): return "/schools/\(id)/students"
                case .getTeachersForSchool(let id): return "/schools/\(id)/teachers"
            }
        }
    }
}
