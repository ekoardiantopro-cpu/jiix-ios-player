# GitHub Upload Guide

## Files to Upload

Upload the project root folder contents:

- `Jiix/`
- `Jiix.xcodeproj/`
- `README.md`
- `.gitignore`

Do not upload:

- `build/`
- `*.xcarchive`
- `DerivedData`
- `xcuserdata`

## GitHub Website Method

1. Create a new repository on GitHub.
2. Name it for example `jiix-ios-player`.
3. Choose `Public` or `Private`.
4. Do not add a README from GitHub if you will upload this folder as-is.
5. Open the new repository page.
6. Click `uploading an existing file`.
7. Drag these items into the page:
   `Jiix/`, `Jiix.xcodeproj/`, `README.md`, `.gitignore`
8. Commit the upload.

## Git Command Method

Run these commands from the project folder after creating an empty repository on GitHub:

```bash
cd /Users/ekozer/Documents/jiix
git init
git add .
git commit -m "Initial Jiix iOS app"
git branch -M main
git remote add origin https://github.com/USERNAME/REPOSITORY.git
git push -u origin main
```

Replace `USERNAME/REPOSITORY` with your repository address.

## After Opening on Another Mac

1. Open `Jiix.xcodeproj`
2. Select the `Jiix` target
3. Open `Signing & Capabilities`
4. Choose your `Team`
5. If needed, change the bundle id to something unique
6. Press `Run`
