# Android release signing (solo dev)

Gradle reads `android/key.properties`. This file is the human-readable copy of the same details.

## Keystore file

| Field | Value |
| --- | --- |
| Path | `android/app/upload-keystore.jks` |
| Type | PKCS12 |
| Alias | `upload` |
| Store password | `interactionsRelease` |
| Key password | `interactionsRelease` |
| Validity | 10,000 days (created 2026-09-30) |

**Distinguished name (DN):** `CN=Interactions, OU=Mobile, O=Local Dev, L=NA, ST=NA, C=US`

**Fingerprints (upload key):**

- SHA-1: `67:59:AE:C0:68:A3:F6:75:D9:C8:E4:85:D3:4A:A4:0D:9F:C6:A6:C7`
- SHA-256: `FB:1E:EC:36:3A:5A:E9:9C:72:D5:05:6F:CD:69:53:83:B4:0A:59:9C:4B:AB:E2:87:EC:6A:00:83:D9:17:E1:75`

## `key.properties` (Gradle)

```properties
storePassword=interactionsRelease
keyPassword=interactionsRelease
keyAlias=upload
storeFile=app/upload-keystore.jks
```

## App IDs

| Platform | Value |
| --- | --- |
| Android `applicationId` | `com.example.interactions` |

## Build & install on device

```bash
# USB debugging on, phone connected
flutter run --release

# Or build APK then install
flutter build apk --release
flutter install --release
```

Release APK output: `build/app/outputs/flutter-apk/app-release.apk`

## Recreate keystore (only if you lose the file)

You will **not** be able to update the same Play Store app if you replace this key later. Back up `upload-keystore.jks` and these passwords.

```bash
keytool -genkeypair -v \
  -keystore android/app/upload-keystore.jks \
  -storetype PKCS12 \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload \
  -storepass interactionsRelease \
  -keypass interactionsRelease \
  -dname "CN=Interactions, OU=Mobile, O=Local Dev, L=NA, ST=NA, C=US"
```

## Play Console

When you publish, use this same upload keystore (or enroll in Play App Signing and upload this key once). Keep this file and `upload-keystore.jks` backed up outside the repo as well.
