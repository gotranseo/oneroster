# OneRoster

A Vapor package for interacting with a OneRoster v1.1 JSON IMS API. 

## What is OneRoster?

OneRoster is a standard developed by IMS Global that specifies how technology providers can communicate with technology repositories of student data. It can be used to auto-populate products when a school subscribes, roster students, and pull grade/demographic information. We built this library to make it easier to interact with. 

## Installation 

OneRoster is available through SPM. To install it, simply add the following to the `dependencies` array in your `Package.swift` file:

```swift
.package(url: "https://github.com/gotranseo/oneroster.git", from: "2.0.0")
```

Don't forget to also add it to your target's dependencies:

```swift
.product(name: "OneRoster", package: "OneRoster")
```

## Usage 

To obtain a client for making OneRoster endpoint requests, call `Application.oneRoster(baseURL:)` or `Request.oneRoster(baseURL:)`. If you are calling a server which requires OAuth 1 authorization, use, the `.oauth1OneRoster(baseURL:clientId:clientSecret:)` method. For an OAuth 2 server, use `.oauth2OneRoster(baseURL:clientId:clientSecret:)`:

```swift
let imsURL = URL(string: "https://ims-server-here/")!
let noAuthClient = req.oneRoster(baseURL: imsURL)
let oauth1Client = req.oauth1OneRoster(baseURL: imsURL, clientId: "my-client-id", clientSecret: "my-client-secret")
let oauth2Client = req.oauth2OneRoster(baseURL: imsURL, clientId: "my-client-id", clientSecret: "my-client-secret")
```

Due to the way OneRoster's API is specified, we are forced to have two different request methods: `.request(_:as:filter:)` for requesting single entities, and `request(_:as:offset:limit:filter:)` for requesting arrays of entities. For example, to call the `getAllSchools` endpoint:

```swift
let data = try client.request(.getAllSchools, as: OneRoster.SchoolsResponse.self, limit: 100, offset: 0)
```

To call a single-entity endpoint, such as `getSchool`:

```swift
let school = try client.request(.getSchool(id: "1"), as: OneRoster.SchoolResponse.self)
```

Enjoy! 
