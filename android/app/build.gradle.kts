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
    namespace = "com.example.projek_akhir_edukasi"
    // --- PERUBAHAN 1 (Sesuai Video) ---
    compileSdk = 36
    // ---------------------------------
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.projek_akhir_edukasi"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        multiDexEnabled = true
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")

            // --- PERUBAHAN 2 (Sesuai Video) ---
            // Menambahkan ProGuard rules untuk ZegoCloud
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
            // ---------------------------------
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.1.2"))
    implementation("com.google.firebase:firebase-auth-ktx")
    
    // INI DIA YANG ANDA CARI
    implementation("androidx.multidex:multidex:2.0.1")
    
    // Anda mungkin juga perlu ini untuk Kotlin
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.23") 
}