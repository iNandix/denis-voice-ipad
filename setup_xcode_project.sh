#!/bin/bash

# Denis AI iPad Voice App - Setup Script
# ======================================

echo "🚀 Configurando Denis AI iPad Voice App..."

# Crear estructura de directorios
echo "📁 Creando estructura de proyecto..."
mkdir -p DenisVoiceApp/Sources/DenisVoice
mkdir -p DenisVoiceApp/Tests/DenisVoiceTests
mkdir -p DenisVoiceApp/DenisVoice/Assets.xcassets
mkdir -p DenisVoiceApp/DenisVoice/Base.lproj

# Mover archivos generados
echo "📄 Moviendo archivos fuente..."
mv *.swift DenisVoiceApp/Sources/DenisVoice/ 2>/dev/null || true
mv Info.plist DenisVoiceApp/DenisVoice/ 2>/dev/null || true
mv Package.swift DenisVoiceApp/ 2>/dev/null || true

# Crear archivo .gitignore
cat > DenisVoiceApp/.gitignore << 'EOF'
.DS_Store
*.xcuserdatad
*.xcscmblueprint
build/
*.build/
DerivedData/
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
*.moved-aside
*.xccheckout
*.xcscmblueprint
*.xcodeproj/xcuserdata/
*.xcodeproj/project.xcworkspace/xcuserdata/
EOF

# Crear DenisVoice.xcodeproj básico
echo "📦 Creando proyecto Xcode básico..."
mkdir -p DenisVoiceApp/DenisVoice.xcodeproj

# Crear project.pbxproj básico
cat > DenisVoiceApp/DenisVoice.xcodeproj/project.pbxproj << 'EOF'
// !$*UTF8*$!
{
    archiveVersion = 1;
    classes = {
    };
    objectVersion = 55;
    objects = {

/* Begin PBXBuildFile section */
        4D2B6F2A2A1B4F8C00123456 /* AppDelegate.swift in Sources */ = {isa = PBXBuildFile; fileRef = 4D2B6F292A1B4F8C00123456 /* AppDelegate.swift */; };
        4D2B6F2C2A1B4F8C00123456 /* ContentView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 4D2B6F2B2A1B4F8C00123456 /* ContentView.swift */; };
        4D2B6F2E2A1B4F8C00123456 /* VoiceManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = 4D2B6F2D2A1B4F8C00123456 /* VoiceManager.swift */; };
        4D2B6F302A1B4F8C00123456 /* WebSocketManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = 4D2B6F2F2A1B4F8C00123456 /* WebSocketManager.swift */; };
        4D2B6F322A1B4F8C00123456 /* FaceIDManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = 4D2B6F312A1B4F8C00123456 /* FaceIDManager.swift */; };
        4D2B6F342A1B4F8C00123456 /* AudioProcessor.swift in Sources */ = {isa = PBXBuildFile; fileRef = 4D2B6F332A1B4F8C00123456 /* AudioProcessor.swift */; };
        4D2B6F362A1B4F8C00123456 /* EmotionDetector.swift in Sources */ = {isa = PBXBuildFile; fileRef = 4D2B6F352A1B4F8C00123456 /* EmotionDetector.swift */; };
        4D2B6F382A1B4F8C00123456 /* ConversationManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = 4D2B6F372A1B4F8C00123456 /* ConversationManager.swift */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
        4D2B6F222A1B4F8C00123456 /* DenisVoice.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = DenisVoice.app; sourceTree = BUILT_PRODUCTS_DIR; };
        4D2B6F252A1B4F8C00123456 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
        4D2B6F292A1B4F8C00123456 /* AppDelegate.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/DenisVoice/AppDelegate.swift; sourceTree = "<group>"; };
        4D2B6F2B2A1B4F8C00123456 /* ContentView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/DenisVoice/ContentView.swift; sourceTree = "<group>"; };
        4D2B6F2D2A1B4F8C00123456 /* VoiceManager.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/DenisVoice/VoiceManager.swift; sourceTree = "<group>"; };
        4D2B6F2F2A1B4F8C00123456 /* WebSocketManager.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/DenisVoice/WebSocketManager.swift; sourceTree = "<group>"; };
        4D2B6F312A1B4F8C00123456 /* FaceIDManager.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/DenisVoice/FaceIDManager.swift; sourceTree = "<group>"; };
        4D2B6F332A1B4F8C00123456 /* AudioProcessor.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/DenisVoice/AudioProcessor.swift; sourceTree = "<group>"; };
        4D2B6F352A1B4F8C00123456 /* EmotionDetector.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/DenisVoice/EmotionDetector.swift; sourceTree = "<group>"; };
        4D2B6F372A1B4F8C00123456 /* ConversationManager.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Sources/DenisVoice/ConversationManager.swift; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
        4D2B6F1F2A1B4F8C00123456 /* Frameworks */ = {
            isa = PBXFrameworksBuildPhase;
            buildActionMask = 2147483647;
            files = (
            );
            runOnlyForDeploymentPostprocessing = 0;
        };
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
        4D2B6F1A2A1B4F8C00123456 = {
            isa = PBXGroup;
            children = (
                4D2B6F242A1B4F8C00123456 /* DenisVoice */,
                4D2B6F232A1B4F8C00123456 /* Products */,
            );
            sourceTree = "<group>";
        };
        4D2B6F232A1B4F8C00123456 /* Products */ = {
            isa = PBXGroup;
            children = (
                4D2B6F222A1B4F8C00123456 /* DenisVoice.app */,
            );
            name = Products;
            sourceTree = "<group>";
        };
        4D2B6F242A1B4F8C00123456 /* DenisVoice */ = {
            isa = PBXGroup;
            children = (
                4D2B6F252A1B4F8C00123456 /* Info.plist */,
                4D2B6F292A1B4F8C00123456 /* AppDelegate.swift */,
                4D2B6F2B2A1B4F8C00123456 /* ContentView.swift */,
                4D2B6F2D2A1B4F8C00123456 /* VoiceManager.swift */,
                4D2B6F2F2A1B4F8C00123456 /* WebSocketManager.swift */,
                4D2B6F312A1B4F8C00123456 /* FaceIDManager.swift */,
                4D2B6F332A1B4F8C00123456 /* AudioProcessor.swift */,
                4D2B6F352A1B4F8C00123456 /* EmotionDetector.swift */,
                4D2B6F372A1B4F8C00123456 /* ConversationManager.swift */,
            );
            path = DenisVoice;
            sourceTree = "<group>";
        };
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
        4D2B6F212A1B4F8C00123456 /* DenisVoice */ = {
            isa = PBXNativeTarget;
            buildConfigurationList = 4D2B6F3B2A1B4F8C00123456 /* Build configuration list for PBXNativeTarget "DenisVoice" */;
            buildPhases = (
                4D2B6F1E2A1B4F8C00123456 /* Sources */,
                4D2B6F1F2A1B4F8C00123456 /* Frameworks */,
                4D2B6F202A1B4F8C00123456 /* Resources */,
            );
            buildRules = (
            );
            dependencies = (
            );
            name = DenisVoice;
            productName = DenisVoice;
            productReference = 4D2B6F222A1B4F8C00123456 /* DenisVoice.app */;
            productType = "com.apple.product-type.application";
        };
/* End PBXNativeTarget section */

/* Begin PBXProject section */
        4D2B6F1B2A1B4F8C00123456 /* Project object */ = {
            isa = PBXProject;
            attributes = {
                BuildIndependentTargetsInParallel = YES;
                LastUpgradeCheck = 1430;
                TargetAttributes = {
                    4D2B6F212A1B4F8C00123456 = {
                        CreatedOnToolsVersion = 14.3;
                    };
                };
            };
            buildConfigurationList = 4D2B6F1D2A1B4F8C00123456 /* Build configuration list for PBXProject "DenisVoice" */;
            compatibilityVersion = "Xcode 14.0";
            developmentRegion = en;
            hasScannedForEncodings = 0;
            knownRegions = (
                en,
                Base,
            );
            mainGroup = 4D2B6F1A2A1B4F8C00123456;
            productRefGroup = 4D2B6F232A1B4F8C00123456 /* Products */;
            projectDirPath = "";
            projectRoot = "";
            targets = (
                4D2B6F212A1B4F8C00123456 /* DenisVoice */,
            );
        };
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
        4D2B6F202A1B4F8C00123456 /* Resources */ = {
            isa = PBXResourcesBuildPhase;
            buildActionMask = 2147483647;
            files = (
            );
            runOnlyForDeploymentPostprocessing = 0;
        };
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
        4D2B6F1E2A1B4F8C00123456 /* Sources */ = {
            isa = PBXSourcesBuildPhase;
            buildActionMask = 2147483647;
            files = (
                4D2B6F2A2A1B4F8C00123456 /* AppDelegate.swift in Sources */,
                4D2B6F2C2A1B4F8C00123456 /* ContentView.swift in Sources */,
                4D2B6F2E2A1B4F8C00123456 /* VoiceManager.swift in Sources */,
                4D2B6F302A1B4F8C00123456 /* WebSocketManager.swift in Sources */,
                4D2B6F322A1B4F8C00123456 /* FaceIDManager.swift in Sources */,
                4D2B6F342A1B4F8C00123456 /* AudioProcessor.swift in Sources */,
                4D2B6F362A1B4F8C00123456 /* EmotionDetector.swift in Sources */,
                4D2B6F382A1B4F8C00123456 /* ConversationManager.swift in Sources */,
            );
            runOnlyForDeploymentPostprocessing = 0;
        };
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
        4D2B6F392A1B4F8C00123456 /* Debug */ = {
            isa = XCBuildConfiguration;
            buildSettings = {
                ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
                ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
                CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
                CODE_SIGN_STYLE = Automatic;
                CURRENT_PROJECT_VERSION = 1;
                DEVELOPMENT_TEAM = "";
                ENABLE_PREVIEWS = YES;
                GENERATE_INFOPLIST_FILE = YES;
                INFOPLIST_FILE = "Info.plist";
                INFOPLIST_KEY_CFBundleDisplayName = DenisVoice;
                INFOPLIST_KEY_LSApplicationCategoryType = "public.app-category.productivity";
                INFOPLIST_KEY_NSCameraUsageDescription = "Face ID authentication for secure access to Denis AI";
                INFOPLIST_KEY_NSFaceIDUsageDescription = "Face ID authentication for secure access to Denis AI";
                INFOPLIST_KEY_NSLocationWhenInUseUsageDescription = "";
                INFOPLIST_KEY_NSMicrophoneUsageDescription = "Voice input for real-time conversation with Denis AI";
                INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
                INFOPLIST_KEY_UILaunchStoryboardName = LaunchScreen;
                INFOPLIST_KEY_UIRequiresFullScreen = NO;
                INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
                INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait";
                INFOPLIST_KEY_UISupportsDocumentBrowser = NO;
                IPHONEOS_DEPLOYMENT_TARGET = 16.0;
                LD_RUNPATH_SEARCH_PATHS = (
                    "$(inherited)",
                    "@executable_path/Frameworks",
                );
                MARKETING_VERSION = 1.0.0;
                PRODUCT_BUNDLE_IDENTIFIER = com.denis.ai.voice;
                PRODUCT_NAME = "$(TARGET_NAME)";
                SDKROOT = iphoneos;
                SUPPORTED_PLATFORMS = "iphoneos iphonesimulator";
                SUPPORTS_MACCATALYST = NO;
                SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD = NO;
                SUPPORTS_XR_DESIGNED_FOR_IPHONE_IPAD = NO;
                SWIFT_EMIT_LOC_STRINGS = YES;
                SWIFT_VERSION = 5.0;
                TARGETED_DEVICE_FAMILY = "1,2";
            };
            name = Debug;
        };
        4D2B6F3A2A1B4F8C00123456 /* Release */ = {
            isa = XCBuildConfiguration;
            buildSettings = {
                ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
                ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
                CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
                CODE_SIGN_STYLE = Automatic;
                CURRENT_PROJECT_VERSION = 1;
                DEVELOPMENT_TEAM = "";
                ENABLE_PREVIEWS = YES;
                GENERATE_INFOPLIST_FILE = YES;
                INFOPLIST_FILE = "Info.plist";
                INFOPLIST_KEY_CFBundleDisplayName = DenisVoice;
                INFOPLIST_KEY_LSApplicationCategoryType = "public.app-category.productivity";
                INFOPLIST_KEY_NSCameraUsageDescription = "Face ID authentication for secure access to Denis AI";
                INFOPLIST_KEY_NSFaceIDUsageDescription = "Face ID authentication for secure access to Denis AI";
                INFOPLIST_KEY_NSLocationWhenInUseUsageDescription = "";
                INFOPLIST_KEY_NSMicrophoneUsageDescription = "Voice input for real-time conversation with Denis AI";
                INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
                INFOPLIST_KEY_UILaunchStoryboardName = LaunchScreen;
                INFOPLIST_KEY_UIRequiresFullScreen = NO;
                INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
                INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait";
                INFOPLIST_KEY_UISupportsDocumentBrowser = NO;
                IPHONEOS_DEPLOYMENT_TARGET = 16.0;
                LD_RUNPATH_SEARCH_PATHS = (
                    "$(inherited)",
                    "@executable_path/Frameworks",
                );
                MARKETING_VERSION = 1.0.0;
                PRODUCT_BUNDLE_IDENTIFIER = com.denis.ai.voice;
                PRODUCT_NAME = "$(TARGET_NAME)";
                SDKROOT = iphoneos;
                SUPPORTED_PLATFORMS = "iphoneos iphonesimulator";
                SUPPORTS_MACCATALYST = NO;
                SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD = NO;
                SUPPORTS_XR_DESIGNED_FOR_IPHONE_IPAD = NO;
                SWIFT_EMIT_LOC_STRINGS = YES;
                SWIFT_VERSION = 5.0;
                TARGETED_DEVICE_FAMILY = "1,2";
            };
            name = Release;
        };
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
        4D2B6F1D2A1B4F8C00123456 /* Build configuration list for PBXProject "DenisVoice" */ = {
            isa = XCConfigurationList;
            buildConfigurations = (
                4D2B6F392A1B4F8C00123456 /* Debug */,
                4D2B6F3A2A1B4F8C00123456 /* Release */,
            );
            defaultConfigurationIsVisible = 0;
            defaultConfigurationName = Release;
        };
        4D2B6F3B2A1B4F8C00123456 /* Build configuration list for PBXNativeTarget "DenisVoice" */ = {
            isa = XCConfigurationList;
            buildConfigurations = (
                4D2B6F3C2A1B4F8C00123456 /* Debug */,
                4D2B6F3D2A1B4F8C00123456 /* Release */,
            );
            defaultConfigurationIsVisible = 0;
            defaultConfigurationName = Release;
        };
/* End XCConfigurationList section */
    };
    rootObject = 4D2B6F1B2A1B4F8C00123456 /* Project object */;
}
EOF

echo "✅ Proyecto Xcode configurado"
echo ""
echo "📱 Para completar la instalación:"
echo "1. Abrir DenisVoiceApp/DenisVoice.xcodeproj en Xcode"
echo "2. Agregar las dependencias Swift Package Manager:"
echo "   - Starscream: https://github.com/daltoniam/Starscream.git"
echo "   - Opus codec (opcional para compresión avanzada)"
echo "3. Configurar Team ID para desarrollo"
echo "4. Compilar y ejecutar en iPad Pro"
echo ""
echo "🎯 La app estará lista para usar con Denis AI!"
