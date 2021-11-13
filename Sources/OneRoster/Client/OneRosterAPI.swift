//===----------------------------------------------------------------------===//
//
// This source file is part of the OneRoster open source project
//
// Copyright (c) 2021 the OneRoster project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

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

        /// Return the collection of courses
        case getAllCourses
        
        /// Return the collection of classes
        case getAllClasses

        /// The endpoint for the resource
        public var endpoint: String {
            switch self {
                case .getAllDemographics: return "demographics"
                case .getDemographics(let id): return "demographics/\(id)"
                case .getAllEnrollments: return "enrollments"
                case .getEnrollment(let id): return "enrollments/\(id)"
                case .getAllOrgs: return "orgs"
                case .getOrg(let id): return "orgs/\(id)"
                case .getAllSchools: return "schools"
                case .getSchool(let id): return "schools/\(id)"
                case .getAllStudents: return "students"
                case .getStudent(let id): return "students/\(id)"
                case .getAllTeachers: return "teachers"
                case .getTeacher(let id): return "teachers/\(id)"
                case .getAllUsers: return "users"
                case .getUser(let id): return "users/\(id)"
                case .getStudentsForSchool(let id): return "schools/\(id)/students"
                case .getTeachersForSchool(let id): return "schools/\(id)/teachers"
                case .getAllCourses: return "courses"
                case .getAllClasses: return "classes"
            }
        }
        
        /// The `Codable` response type for the resource
        public var responseType: Codable.Type {
            switch self {
                case .getAllDemographics: return DemographicsResponse.self
                case .getDemographics: return DemographicResponse.self
                case .getAllEnrollments: return EnrollmentsResponse.self
                case .getEnrollment: return EnrollmentResponse.self
                case .getAllOrgs: return OrgsResponse.self
                case .getOrg: return OrgResponse.self
                case .getAllSchools: return SchoolsResponse.self
                case .getSchool: return SchoolResponse.self
                case .getAllStudents: return StudentsResponse.self
                case .getStudent: return StudentResponse.self
                case .getAllTeachers: return TeachersResponse.self
                case .getTeacher: return TeacherResponse.self
                case .getAllUsers: return UsersResponse.self
                case .getUser: return UserResponse.self
                case .getStudentsForSchool: return StudentsForSchoolResponse.self
                case .getTeachersForSchool: return TeachersForSchoolResponse.self
                case .getAllCourses: return CoursesResponse.self
                case .getAllClasses: return ClassesResponse.self
            }
        }
    }
}
