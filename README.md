#  CascableCore Simulated Camera

This Swift Package Manager/SPM package contains a plugin for [CascableCore](https://github.com/cascable/cascablecore-distribution/) that provides a "simulated" camera through the regular CascableCore APIs. By including this package in your CascableCore-using product, you can work with the simulated camera with just a few lines of code.

<p align="center">
	<img width="800" src="https://github.com/Cascable/cascablecore-simulated-camera/assets/514900/344d1024-0238-4328-8bcc-70bcbdd68f47"><br>
	<em>The simulated camera in use in some of Cascable's apps.</em>
</p>

### Contents

- [What It's Bad For](#what-its-bad-for)
- [What It's Good For](#what-its-good-for)
- [Adding the Simulated Camera to Your Project](#adding-the-simulated-camera-to-your-project)
- [Configuring the Simulated Camera](#configuring-the-simulated-camera)
- [Limitations](#limitations)

### What It's Bad For

🚨 **Important:** 🚨 The simulated camera is **not** a replacement for testing your app with real cameras. Real cameras are complicated, subject to the user providing input via them, and have whims and lifecycles of their own. The simulated camera plugin makes no attempt to replicate these details.

### What It's Good For

What the simulated camera *is* good for, however, is drastically simplifying day-to-day development, testing camera UI flows you may not have access to, implementing UI tests, and even producing marketing materials.

Some example use cases include:

- Having a simulated camera allows access to portions of your app that require a connected camera, allowing development of these portions without needing a real camera constantly around.

- The simulated camera can be configured with different authentication types and property types, allowing the testing of the various UI pieces needed for these different variations without having to have many different cameras always at hand.

- The simulated camera is available in the simulator and without any network access, meaning it can be used by automated UI tests (tip: set the simulated camera's `connectionSpeed` to `.instant` for snappy and repeatable tests).

- The simulated camera can be configured with a custom model name and live view images, making it great for producing marketing images. Many of the marketing screenshots used on [our own website](https://cascable.se/ios/) and App Store pages were produced automatically using UI automation and the simulated camera plugin.

### Adding the Simulated Camera to Your Project

Adding the simulated camera to your project is easy - simply add this package to your project as you would any other Swift Package Manager package, then `import CascableCoreSimulatedCamera` near your camera connection code. The CascableCore plugin system will pick up and load the plugin when your application runs.

**Note:** Since the simulated camera plugin is built alongside CascableCore, it has fairly tight version requirements to the CascableCore distribution package.

Plugin loading is done via the CascableCore `CameraDiscovery` class. You can check that the plugin is loaded by checking the `loadedPluginIdentifiers` property:

```swift
import CascableCore
import CascableCoreSimulatedCamera

let cameraDiscovery = CameraDiscovery.shared

if cameraDiscovery.loadedPluginIdentifiers.contains(SimulatedCameraEntryPoint.pluginIdentifier) {
    print("Simulated camera is loaded!")
}
```

CascableCore enables all plugins by default. It's probably not a good idea to have the simulated camera enabled in builds distributed to your customers (at least not by default), so it's important to disable it if it's not wanted. For example, maybe you only want it enabled for debug builds:

```swift 
#if DEBUG
cameraDiscovery.setEnabled(true, forPluginWithIdentifier: SimulatedCameraEntryPoint.pluginIdentifier)
#else
cameraDiscovery.setEnabled(false, forPluginWithIdentifier: SimulatedCameraEntryPoint.pluginIdentifier)
#endif

if cameraDiscovery.enabledPluginIdentifiers.contains(SimulatedCameraEntryPoint.pluginIdentifier) {
    print("Simulated camera is enabled!")
}
```

Once added and enabled (or, rather, not disabled), the simulated camera will be delivered through the same camera discovery process you'd use for any other camera.

### Configuring the Simulated Camera

The simulated camera is set up with some sensible defaults by default, but you can configure various aspects of it to suit your needs via the `SimulatedCameraConfiguration` struct.

**Important:** You must apply configuration changes before the simulated camera is discovered by CascableCore. The best way to ensure this is to apply your changes before calling `beginSearching()` on the `CameraDiscovery` object:

```swift  
import CascableCore
import CascableCoreSimulatedCamera

var config: SimulatedCameraConfiguration = .default
config.connectionAuthentication = .fourDigitCode("1234")
config.connectionSpeed = .fast
config.apply() // You *must* call this method for changes to take effect.

let cameraDiscovery = CameraDiscovery.shared
cameraDiscovery.delegate = self
cameraDiscovery.beginSearching()
```

The `SimulatedCameraConfiguration` struct has the following properties:

- **manufacturer**: The simulated camera's manufacturer name. The default value is `Cascable`.

- **model**: The simulated camera's model name. The default value is `Simulated Camera`.

- **identifier**: The simulated camera's identifier, which will be used for serial numbers, authentication identifiers, etc. The default value is the plugin's identifier (`se.cascable.CascableCore.plugin.simulated-camera`).

- **connectionAuthentication**: Which authentication type to perform when connecting to the simulated camera. The default value is `.pairOnCamera`.

- **connectionSpeed**: The simulated connection speed. The default value is `.fast`.

- **connectionTransports**: Which transport(s) the simulated camera will be discovered on. The default value is `[.network, .USB]`.

- **exposurePropertyType**: How simulated exposure properties (aperture, shutter speed, ISO, etc) are set. Defaults to `.enumerated`.

- **liveViewImageFrames**: An array of local file URLs to JPEG images to be used as the live view stream. These images will be loaded upon live view start and delivered in a loop at approximately 30fps. The images must all be the same size and around 720p (or the 3:2 or 4:3 equivalent) or so to be accurate. Setting an array of one item is valid for a static image. Setting an empty array or including non-JPEG images will cause the simulated live view stream to fail.

- **storageFileSystemRoot**: The local filesystem URL to expose as a storage device on the simulated camera. When set to an accessible directory, the simulated camera will use that directory's contents to populate the camera's storage device. For best results, it should simulate a real layout (`/DCIM/100CAMERA/etc`). The default value is `nil`.

- **fileSystemAccess**: How the simulated camera grants filesystem access. Defaults to `.alongsideRemoteShooting`.

### Limitations

The simulated camera has been an internal Cascable tool for a few years, and these initial versions are largely a tidyup and documentation effort of that internal plugin. As such, a decent amount of more advanced functionality has yet to be implemented. We'll be improving the plugin over time — if any missing features are particularly important to you, please let us know.

#### Camera Discovery & Connection  

- ✅ Customisation of camera manufacturer, name, identifier, etc
- ✅ Customisation of simulated connection speed
- ✅ Simulation of all connection authentication types

#### Properties

- ✅ Exposure settings based on autoexposure mode 
- ✅ Enumerated property setting
- ✅ Stepped property setting
- ✅ Basic properties
- ❌ Full range of properties

#### Photo & Video Shooting

- ✅ Basic shooting
- ❌ Autoexposure results
- ❌ Direct focus manipulation
- ✅ Camera-initiated transfers for previews
- ❌ Camera-initiated transfers for original images ("tethering")
- ✅ Video recording
- ✅ Switching the simulated camera between stills shooting, video recording, and filesystem modes 

#### Live View

- ✅ Live view streaming with customisable image feed
- ✅ Application of the `CBLLiveViewOptionSkipImageDecoding` setting
- ❌ Application of the `CBLLiveViewOptionFavorHighFrameRate` setting
- ❌ Live view rotation
- ❌ Tap-to-focus, focus point geometry
- ❌ Live view zoom

#### Filesystem Access

- ✅ Read-only access to the file system
- ❌ Filesystem event observation
- ❌ Read-write access to the file system (file deletion, etc)

#### Misc. Features

- ❌ Clock updating
