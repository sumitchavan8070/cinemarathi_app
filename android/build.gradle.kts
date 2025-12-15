// android/build.gradle.kts
import org.gradle.api.tasks.Delete

plugins {
    id("com.google.gms.google-services") version "4.4.4" apply false
}

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

// Flutter build directory override (AGP 8 + KTS safe)
rootProject.layout.buildDirectory.set(
    rootProject.layout.projectDirectory.dir("../build")
)

subprojects {
    layout.buildDirectory.set(rootProject.layout.buildDirectory.dir(name))
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
