# Greenplay Mobile Application

## Installation

1. If you're installing on an Apple Silicon Mac, the **Rosetta translation environment** must be installed for ancillary tools. You can install it by running this command:
    
    ```bash
    sudo softwareupdate --install-rosetta --agree-to-license
    ```
    
2. **Download the Flutter SDK**
For Intel Macs, use the following command:
    
    ```bash
    curl https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.3.6-stable.zip --output ~/Downloads/flutter.zip
    ```
    
    For **Apple Silicon Macs**, use the following command:
    
    ```bash
    curl https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.3.6-stable.zip --output ~/Downloads/flutter.zip
    ```
    
3. **Extract the Flutter tool**
Unzip the downloaded file to the desired development location. Make sure to replace `[PATH_TO_FLUTTER]` with the path where you wish to install flutter to.
    
    ```bash
    cd ~/[PATH_TO_FLUTTER]
    unzip ~/Downloads/flutter.zip
    ```
    
4. **Update the PATH**
To issue `flutter` commands in any terminal session we need to update the PATH variable permanently.

Typing `echo $SHELL` in your terminal tells you which shell you’re using.
    - If you’re using bash, edit `$HOME/.bash_profile` or `$HOME/.bashrc`
    - If you’re using Z shell, edit `$HOME/.zshrc`
    - If you’re using a different shell, the file path and filename will be different on your machine.
    
    Add the following line and change `[PATH_TO_FLUTTER]` to be the path of the downloaded flutter repository.
    
    ```bash
    export PATH="$PATH:[PATH_TO_FLUTTER]/bin"
    ```
    
    After reopening the terminal window, verify that the flutter command is available by running:
    
    ```bash
    which flutter
    ```
    
    This should return the path to your flutter installation.
    

## iOS Setup

To develop Flutter apps for iOS, you need a Mac with Xcode installed.

1. Download XCode from the [AppStore](https://apps.apple.com/de/app/xcode/id497799835?mt=12).
2. Open XCode at least once and and agree to the licenses.

Downloading XCode will automatically install the necessary Developer Tools, in particular the Simulator. You may use **XCode > Open Developer Tool > Simulator** or search for Simulator in Spotlight to create and open new iOS simulators.

Make sure to run a simulated device of your choice at least once for Flutter to recognize its availability.

## Android Setup

<aside>
⚠️ Flutter relies on a full installation of Android Studio to supply its Android platform dependencies.

</aside>

### Install Android Studio

1. [Download and install Android Studio](https://developer.android.com/studio) for your machine.
2. Start Android Studio, and go through the **Android Studio Setup Wizard** which installs the latest Android SDK, Android SDK Command-line Tools, and Android SDK Build-Tools, which are required by Flutter when developing for Android.
3. Run `flutter doctor` to confirm that Flutter has located your installation of Android Studio.

### Simulator

1. Launch **Android Studio**.
2. On the Welcome Screen under **Projects** click on **More Actions**.
3. Select **Virtual Device Manager**.
4. **Create a new device** using the button on the top left.
5. **Select a device** and hit **Next**.
    
    <aside>
    ⚠️ Make sure to select a device which supports the Google Play Store which can be identified by looking at the “Play Store” column in the list of available devices.
    The Google Pixel 4 is a good choice to start.
    
    </aside>
    
6. Select the latest system image, give the simulator a distinct name and click on **Finish**.

### Physical Device

In order to operate the Flutter app on an Android device it must run Android 4.1 or higher.

1. Enable **Developer options** and **USB debugging** on your device. Further information and instruction are available [here](https://developer.android.com/studio/debug/dev-options).
2. If you are running on Windows, [download install the Google USB Driver](https://developer.android.com/studio/run/win-usb).
3. Plug the device into the computer using a USB cable and grant access if prompted.
4. You may run `flutter devices` to verify that Flutter recognizes your connected Android device.

### Agree to Android Licences

Before you can use Flutter to run Android application in the simulator you must agree to the licenses of the Android SDK platform.

1. Open an elevated console window and run `flutter doctor --android-licenses` to begin signing licenses.
2. After (carefully) reviewing each license agree to each of them.

## **Integrated Development Environment**

We are using VS Code as it includes full Flutter app execution and debug support.
Make sure you [download the latest stable version here](https://code.visualstudio.com/).

### Install Plugins

1. Invoke **View** (Anzeigen) **>** **Command Palette** (Befehlspalette).
2. Type **Install Extensions** and select it from the menu.
3. Type **Flutter**, select it and click on install. This will automatically install the Dart plugin as well.

## Open Project in VSCode

Open VS Code and using **File > Open Folder** select the root folder of the cloned repository.

## Doctor

Open a new terminal session and use `flutter doctor` (or `flutter doctor -v`) to confirm that you are ready to use flutter. The result should look something like this:

```bash
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.3.6, on macOS 12.4 21F79 darwin-arm, locale de-DE)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0)
[✓] Xcode - develop for iOS and macOS (Xcode 13.4.1)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2021.3)
[✓] IntelliJ IDEA Ultimate Edition (version 2022.1.1)
[✓] VS Code (version 1.72.2)
[✓] Connected device (2 available)
[✓] HTTP Host Availability

• No issues found!
```

## Analyze and Testing

In the repository folder, you may execute `flutter analyze` to compile the project and `flutter test` to perform the defined unit tests.

If everything works and no issues are detect, you may start developing a new feature for the mobile application in Flutter 🚀.
