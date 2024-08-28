# Implementación de Background y Foreground Notifications.

## Configuraciones
En el archivo android/app/build.gradle

```
dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib:1.8.22"
}

configurations.all {
    resolutionStrategy {
        force 'org.jetbrains.kotlin:kotlin-stdlib:1.8.22'
        force 'org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.8.22'
    }
}
```
