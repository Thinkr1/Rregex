<p align="center">
  <img alt="GitHub Release" src="https://img.shields.io/github/v/release/Thinkr1/Rregex?style=for-the-badge">
  <img als="PRs Welcome" src="https://img.shields.io/badge/PRs-Welcome :)-green?style=for-the-badge">
  <img alt="GitHub commits since latest release" src="https://img.shields.io/github/commits-since/Thinkr1/Rregex/latest?style=for-the-badge">
  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/Thinkr1/Rregex?style=for-the-badge">
  <img alt="GitHub Downloads (all assets, all releases)" src="https://img.shields.io/github/downloads/Thinkr1/Rregex/total?style=for-the-badge">
  <img alt="GitHub License" src="https://img.shields.io/github/license/Thinkr1/Rregex?style=for-the-badge">
  <img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/Thinkr1/Rregex?style=for-the-badge">
</p>

# Rregex

A sleek macOS app to test your regex's. Contains ability to modify target text, save regex's, apply different flags, and fills memory gaps with the help of a cheatsheet!

<img width="1028" height="562" alt="Screenshot 2025-09-28 at 5 31 43 PM" src="https://github.com/user-attachments/assets/5b403dd5-55b4-4878-bcc0-ad9e2354e21e" />

## Install

1. Download the dmg from the [latest release](https://github.com/Thinkr1/Rregex/releases)
2. As I don't have a paid developer account, I cannot direcly notarize the app and you'll be presented with an alert saying it cannot be opened directly. Here are two options:

a) You can run the following command and then open the app normally: 

```sh
sudo xattr -rd com.apple.quarantine /path/to/app/folder/Rregex.app
```

b) You can allow the app to be opened in *System Settings > Privacy & Security* by clicking "Open Anyway" for Rregex.app:

<img width="458" alt="Screenshot 2025-04-21 at 3 55 00 PM" src="https://github.com/user-attachments/assets/8c5c429a-035c-48d4-a51d-95e53bcb9c50" />

---

### Verify File Integrity

You can verify that your download hasn’t been tampered with by checking its SHA-256 checksum.

1. Download the matching .sha256 file:

From the release page, download:

- Rregex.dmg.sha256 if you downloaded the `.dmg`
- Rregex.zip.sha256 if you downloaded the `.zip`

2. Verify the file integrity through the command line *(make sure the downloaded dmg or zip is in the same folder as the checksum)*:

```sh
# For the DMG
shasum -a 256 -c Rregex.dmg.sha256

# For the ZIP
shasum -a 256 -c Rregex.zip.sha256
```

## Contributions

Pull requests are welcome! Whether it's a bug fix, feature suggestion, or just a cool idea—[open an issue](https://github.com/Thinkr1/Rregex/issues/new/choose) or submit a PR.

## License

This project is released under the [MIT License](LICENSE).
