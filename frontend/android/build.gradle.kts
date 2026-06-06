// Root-level Gradle configuration for this Flutter project.
// Keep this file minimal: module-specific Android configuration lives in
// android/app/build.gradle.kts and the Flutter Gradle plugin is applied there.

buildscript {
    repositories {
        google()
        mavenCentral()
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// No Android plugins or `flutter` references here to avoid unresolved symbols.
