# OneRoster

A Vapor package for interacting with a OneRoster v1.1 JSON IMS API. 

## Installation 

OneRoster is available through SPM. To install it, simply add the following to your Package.swift file:

.package(url: "https://github.com/gotranseo/oneroster.git", from: "0.0.1") Don't forget to also add it to dependencies array.


## Usage 

Start by registering the object to your services: 

```swift
services.register { container -> OneRosterClient 
    return OneRosterClient(client: try container.make())
}
```

Then, inside of a controller: 

```swift
let client = try req.make(OneRosterClient.self)
```

Due to the way OneRoster has their API spec we are forced to have two different request method, `requestMultiple` and `requestSingle`. If you are fetching an array of entities, like `getAllSchools`, do this:

```swift
let data = try client.requestMultiple(baseUrl: "ims-url-here",
                                      clientId: "my-client-id",
                                      clientSecret: "my-client-secret",
                                      endpoint: .getAllSchools,
                                      limit: 100,
                                      offset: 0,
                                      decoding: OneRoster.SchoolsResponse.self)
```

By default, the function will go through and recursively query all objects. You can disable this by setting the `bypassRecursion` flag: 

```swift
let data = try client.requestMultiple(baseUrl: "ims-url-here",
                                      clientId: "my-client-id",
                                      clientSecret: "my-client-secret",
                                      endpoint: .getAllSchools,
                                      limit: 100,
                                      offset: 0,
                                      decoding: OneRoster.SchoolsResponse.self,
                                      bypassRecursion: true)
```

If you just want a single model, do the following: 

```swift
let school = try client.requestSingle(baseUrl: "ims-url-here",
                                      clientId: "my-client-id",
                                      clientSecret: "my-client-secret",
                                      endpoint: .getSchool(id: "1"))

```

The library handles all of the OAuth 1.0 grossness for you so that you can focus on building cool Ed-Tech stuff. Enjoy! 

## Copyright
Copyright Slate Solutions, Inc.
