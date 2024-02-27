<p align="center">
    <img width="400px" src=https://user-images.githubusercontent.com/1587270/74537466-25c19e00-4f08-11ea-8cc9-111b6bbf86cc.png>
</p>
<h1 align="center">passninja-swift</h1>
<h3 align="center">
Use <a href="https://passninja.com/docs">passninja-swift</a> as an iOS package.</h3>

<div align="center">
    <a href="https://github.com/flomio/passninja-swift">
        <img alt="Status" src="https://img.shields.io/badge/status-active-success.svg" />
    </a>
    <a href="https://github.com/flomio/passninja-js/issues">
        <img alt="Issues" src="https://img.shields.io/github/issues/flomio/passninja-swift.svg" />
    </a>
    <a href="https://www.ios.com/package/@passninja/passninja-swift">
        <img alt="ios package" src="https://img.shields.io/ios/v/@passninja/passninja-swift.svg?style=flat-square" />
    </a>
</div>

# Contents

- [Contents](#contents)
- [Installation](#installation)
- [Usage](#usage)
  - [`PassNinjaClient`](#passninjaclient)
  - [`PassNinjaClient Methods`](#passninjaclientmethods)
  - [Script Tag](#script-tag)
  - [Examples](#examples)
- [TypeScript support](#typescript-support)
- [Documentation](#documentation)

# Installation
### Swift Package Manager (Xcode 11 and above)
1. Select `File`/`Swift Packages`/`Add Package Dependency…` from the menu.
1. Paste `https://github.com/flomio/passninja-swift.git`.
1. Follow the steps and select from main branch.

# Usage

## `PassNinjaClient`

Use this class to init a `Passninja` object. Make sure to
pass your user credentials to make any authenticated requests.

```swift
import PassNinjaSwift

let accountId = "**your-account-id**"
let apiKey = "**your-api-key**"

PassNinja.initWith(accountId: accountId, apiKey: apiKey)
```

We've placed our demo user API credentials in this example. Replace it with your
[actual API credentials](https://passninja.com/auth/profile) to test this code
through your PassNinja account and don't hesitate to contact
[PassNinja](https://passninja.com) with our built in chat system if you'd like
to subscribe and create your own custom pass type(s).

For more information on how to use `passninja-swift` once it loads, please refer to
the [PassNinja Swift API reference](https://passninja.com/docs/swift)

## `PassNinjaClientMethods`

This library currently supports methods for creating, getting, updating, and
deleting passes via the PassNinja api. The methods are outlined below.

### Create

```swift
PassClient.shared.createPass(pass: PassRequest(passType: "demo.coupon", pass: [discount: '50%', memberName: 'John']), onSuccess: { (pass) in
    print(pass.urls as Any)
    print(pass.passType as Any)
    print(pass.serialNumber as Any)
    print(pass.pass?.logoText as Any)
    print(pass.pass?.descriptionField as Any)
}) { (error) in
    print(error as Any)
}

```

### Get

```swift
PassClient.shared.getPass(passType: "demo.coupon", serialNumber: "#Your pass serial number", onSuccess: { (pass) in
    print(pass.urls as Any)
    print(pass.passType as Any)
    print(pass.serialNumber as Any)
    print(pass.pass?.logoText as Any)
    print(pass.pass?.descriptionField as Any)
}) { (error) in
    print(error as Any)
}
```

### Get Pass Template Details

```swift
PassClient.shared.getPassTemplate(passType: "demo.coupon", onSuccess: { (passTemplate) in
    print(pass.id as Any)
    print(pass.passTypeId as Any)
    print(pass.name as Any)
}) { (error) in
    print(error as Any)
}

```

### Update

```swift
PassClient.shared.putPass(pass: PassRequest(passType: "demo.coupon", pass: ["passTitle": "Example passTitleValue", "logoText": "Example logoTextValue", "organizationName": "Example organizationNameValue", "description": "Example descriptionValue"], serialNumber: "#Your pass serial number"), onSuccess: { (pass) in
    print(pass.urls as Any)
    print(pass.passType as Any)
    print(pass.serialNumber as Any)
    print(pass.pass?.logoText as Any)
    print(pass.pass?.descriptionField as Any)
    print(pass.pass?.expiration as Any)
}) { (error) in
    print(error as Any)
}
```

### Delete

```swift
PassClient.shared.deletePass(passType: "demo.coupon", serialNumber: pass?.serialNumber ?? "", clientPassData: [:], onSuccess: {
    print("Pass deleted successfully")
}) { (error) in
    print(error as Any)
}
```

# Documentation

- [PassNinja Docs](https://passninja.com/documentation)
