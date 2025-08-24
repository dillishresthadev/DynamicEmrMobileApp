plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.paaila_technologies.dynamicemr_android"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        // Enable desugaring
        isCoreLibraryDesugaringEnabled = true

        // Use Java 11
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
    applicationId = "com.paaila_technologies.dynamicemr_android"
    minSdk = flutter.minSdkVersion.toInt()
    targetSdk = flutter.targetSdkVersion.toInt()
    versionCode = flutter.versionCode.toInt()
    versionName = flutter.versionName
    multiDexEnabled = true
    }


    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.0")

    // ✅ Kotlin DSL syntax for desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
