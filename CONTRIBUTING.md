# Contributing

## Testing

Once in Xcode, select the `OneRoster` scheme and use `Cmd-U` to run the tests.

Don't forget to add tests for your new features and fixes.

## Style Guide

Please try to follow existing style for consistency. 

### Xcode Formatting

Avoid using "Xcode style" indentation where possible. This can be difficult to recreate in other editors.

❌
```swift
func foo(bar: String,
         baz: Int) {
    ...
}
```

Use normal indentation instead.

✅
```swift
func foo(
    bar: String,
    baz: Int
) {
    ...
}
```

### Explicit self

When accessing member properties and methods, use explicit `self`. 

```swift
struct Foo {
    var bar: Int
    func baz() {
        // ❌
        print(bar)
        // ✅
        print(self.bar)
    }
}
```

This makes it easier to tell whether a local variable is being used or not, especially when reading code without syntax highlighting.

## SemVer

This package follows [SemVer](https://semver.org). This means that any changes to the source code that can cause existing code to stop compiling _must_ wait until the next major version to be included. 

Code that is only additive and will not break any existing code can be included in the next minor release.

### Clean SPM

Add the following code to your bash profile to make cleaning SPM temporary files easy.

```bash
# Cleans out all temporary SPM files
_spm_clean() {
    rm Package.resolved
    rm -rf .build
    rm -rf *.xcodeproj
    rm -rf .swiftpm
    rm -rf Packages
}
alias spm-clean='_spm_clean'
```

Once added, you can run `spm-clean`.

```bash
spm-clean
```
