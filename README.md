# Denis AI iPad Voice App - Deployment Guide

## 🔑 Apple Developer Credentials
- **Apple ID:** niuka22@hotmail.com
- **Password:** Simbaleon1234$

## 🚀 Deployment Options

Since the Mac (192.168.1.132) doesn't have Xcode installed, choose one of these deployment methods:

### Option 1: Codemagic CI/CD (Recommended - No Xcode Required)
1. Create a Codemagic account at https://codemagic.io/
2. Create new iOS project and upload `codemagic_config.yaml`
3. **Configure Environment Variables:**
   - `APPLE_ID`: niuka22@hotmail.com
   - `APPLE_ID_PASSWORD`: Simbaleon1234$
   - `BUNDLE_ID`: com.denis.voiceapp (or your chosen bundle ID)
4. Upload the `denis_voice_ipad_app_complete.tar.gz` as build source
5. Configure code signing in Codemagic dashboard
6. Trigger build - Codemagic will handle Xcode compilation

### Option 2: GitHub Actions (Free)
1. Create a GitHub repository
2. Upload all files from this directory
3. **Configure Repository Secrets:**
   - Go to Settings → Secrets and variables → Actions
   - Add: `APPLE_ID` = niuka22@hotmail.com
   - Add: `APPLE_ID_PASSWORD` = Simbaleon1234$
   - Add: `APP_STORE_CONNECT_PRIVATE_KEY` (if using TestFlight)
4. Push to main branch to trigger the workflow
5. Download IPA from Actions artifacts

### Option 3: Manual Transfer to Mac with Xcode
If you get Xcode installed on the Mac:
1. Transfer `denis_ios_deployment_ready.tar.gz` to Mac:
   ```bash
   scp denis_ios_deployment_ready.tar.gz franco07@192.168.1.132:~/
   ```
2. On Mac, extract and open in Xcode:
   ```bash
   tar -xzf denis_ios_deployment_ready.tar.gz
   cd ios_app
   tar -xzf denis_voice_ipad_app_complete.tar.gz
   open DenisVoiceApp/Denis.xcodeproj
   ```
3. Sign in with Apple ID: niuka22@hotmail.com / Simbaleon1234$
4. Configure signing & capabilities
5. Build and deploy to iPad Pro 3

## 📋 Prerequisites
- Apple Developer Program membership ($99/year)
- iPad Pro 3 device for testing
- Distribution certificate and provisioning profile (auto-generated)

## 🔧 Configuration Files
- `codemagic_config.yaml` - Codemagic CI/CD configuration
- `.github/workflows/github_workflow.yml` - GitHub Actions workflow
- `denis_voice_ipad_app_complete.tar.gz` - Complete iOS app package
- `export_options.plist` - Export configuration

## 🎯 Target Device
- iPad Pro 3rd generation (11-inch or 12.9-inch)
- iOS 15.0+ recommended

## 📦 Deployment Package
- **File:** `denis_ios_deployment_ready.tar.gz` (21K)
- **Location:** `/media/jotah/SSD_denis/DENIS_SYSTEM/deploy/ios_app/`
- **Contents:** All configs, workflows, and app source

## 📞 Support
Contact Denis AI team for deployment assistance.