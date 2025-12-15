plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.sumit.cinemarathi"

    compileSdk = 35      // ← UPDATED
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11

        // REQUIRED by Flutter Local Notifications plugin (desugaring)
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.sumit.cinemarathi"
        minSdk = 23
        targetSdk = 35      // ← UPDATED

        multiDexEnabled = true

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // TODO: Set your keystore here
            // storeFile = file("key.jks")
            // storePassword = "xxx"
            // keyAlias = "xxx"
            // keyPassword = "xxx"
        }
    }

    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            // Important: no shrinkResources
        }

        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true   // ✅ CORRECT KTS SYNTAX

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

dependencies {
    // Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.6.0"))
    implementation("com.google.firebase:firebase-analytics")

    // REQUIRED for flutter_local_notifications & Java 8 APIs
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
