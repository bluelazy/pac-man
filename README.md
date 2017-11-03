# PortableApps Compiler - _Development Branch_
----------

This branch is meant for the cutting-edge of development. Don't expect this version to work flawlessly. There may be bugs hidden throughout this experimental version of PortableApps Compiler. With that said, enjoy the fresh ideas which are currently being worked out.

## CHANGES
----------

- All environment variables that start with `PAL` have been changed to `PAC` 
  - _I.E._ `%PAL:AppDir%` is now `%PAC:AppDir%` and so on..
- All environment variables that start with `PortableApps.com` have been changed to `PortableApps` 
  - _I.E._ `%PortableApps.comDocuments%` is now `%PortableAppsDocuments%` and so on..

## Features
----------

The following is a list of features that is currently available with PortableApps Compiler. Everything listed here has been tested and is in working order.

- Everything that is available with [PortableApps.com Launcher](https://portableapps.com/apps/development/portableapps.com_launcher) is also available with PortableApps Compiler.
- Minipulating Windows Services.
- Dealing with Windows Tasks.
- Registering DLL files.
- Registry redirection support.
- File-system redirection support.
- Automatic code-signing.
- Font support for apps that make use of fonts.
- More feature soon to come!

----------

#### __Launcher.ini__

__Environment Variables__

- `%PROGRAMDATA%` has now been added and kept `%ALLUSERSAPPDATA%` for backwards compatibility. Both can be used anywhere you can use an evironment variable.
- `%PAL:CommonFiles%` may now be used within the _Launcher.ini_ configuration file. This environment variable will point to `..\PortableApps\CommonFiles` if applicable. Can be used anywhere you can use an environment variable.
> Example:
> ```INI
> [Environment]
> PATH=%PATH%;%PAL:CommonFiles%\AndroidSDK
> JAVA_HOME=%PAL:CommonFiles%\Java64
> ```

Added new keys to the `[Activate]` section. They are as follows (a short description of what each key means or does can be found further below):
> Note: You should only use the following keys if you need them, otherwise they should be omitted entirely.
```INI
[Activate]
Registry=true
RegRedirection=true
RegCopyKeys=true
Redirection=true
ForceRedirection=true
ExecAsUser=true
Services=true
RegDLLs=true
Tasks=true
Java=true
JDK=true
XML=true
Ghostscript=true
FontsFolder=true
FileCleanup=true
DirectoryCleanup=true
```

* __Registry:__ Add support for manipulating the Windows Registry.

* __RegRedirection:__ Enable support for enabling/disabling registry redirection.

* __RegCopyKeys:__ Enable support for copying registry keys to a special hive (`HKCU\Software\PortableApps.com`) before launching the application and restoring the keys after the application exits. See `RegistryCopyKeys.nsh` in the Segments directory.
> To use this feature add the section `[RegistryCopyKeys]` to the `Launcher.ini` file. Each entry should be the path to the registry key to be copied back and forth. Example usage:
> ```INI
> [RegistryCopyKeys]
> 1=HKCU\Software\MyProgram\ExtraCareNeededKey
> 2=HKLM\SOFTWARE\MyProgram\AnotherFragileKey
> ```

* __Redirection:__ Enable support for enabling/disabling file system redirection.

* __ForceRedirection:__ Checks using the variable `$Bit` to disable/enable file system redirection.

* __ExecAsUser:__ For applications which need to run as normal user but need the launcher to have elevated privileges. [Read this](http://mdb-blog.blogspot.com/2013/01/nsis-lunch-program-as-user-from-uac.html) for more information on this concept.

* __Services:__ Add support for handling Windows Services.
> To use this feature add the section `[Service1]` (numerical ordering) to the `Launcher.ini` file. Each entry supports six keys which are as follows:

| __Key__ 	| __Value__ 	|
|:--------	|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| Name 	| The local/portable service name. 	|
| Path 	| The path to the portable service executable. Supports environment variables. 	|
| Type 	| Specify whether you are dealing with a service, a kernel driver or a file system driver, etc.<br />Choose from: _own_, _share_, _interact_, _kernel_, _filesys_, _rec_ 	|
| Start 	| Specify when the service is supposed to start.<br />Choose from: _boot_, _system_, _auto_, _demand_, _disabled_, _delayed-auto_ 	|
| Depend 	| List any dependencies here separated by `/` (forward slash). 	|
| IfExists 	| If the service already exists, you can either skip it or replace it with the portable version of the service (the original service will be restored afterwards).<br />Choose from: _skip_, _replace_ 	|

> Example usage:
> ```INI
> [Service1]
> Name=SomeServiceName
> Path=%PAL:AppDir%\service32.sys
> Type=kernel
> Start=auto
> Depend=
> IfExists=replace
>
> [Service2]
> Name=AnotherService
> Path=%PAL:DataDir%\service64.exe
> Type=own
> Start=demand
> Depend=
> IfExists=skip
> ```

* __RegDLLs:__ Add support for handling library (DLLs) file registration.
> To use this feature add the section `[RegisterDLL1]` (numerical ordering) to the `Launcher.ini` file. Each entry supports two keys; _ProgID_ (The DLL's ProgID) and _File_ (The path to DLL. Supports environment variables). Example usage:
> ```INI
> [RegisterDLL1]
> ProgID=MyAppControlPanel
> File=%PAL:AppDir%\controller.cpl
>
> [RegisterDLL2]
> ProgID=DynamicLibrary
> File=%PAL:DataDir%\dynlib.dll
> ```

* __Tasks:__ Enable the TaskCleanup segment for removing any Windows Tasks that were added during runtime.
> To use this feature add the section `[TaskCleanup]` to the `Launcher.ini` file. Each entry should be the Windows Task name to be removed. Example usage:
> ```INI
> [TaskCleanup]
> 1=MyAppTask1
> 2=Another Task w/ Spaces
> ```

* __Java:__ Add support for the Java Runtime Environment.

* __JDK:__ Add support for the Java Development Kit.

* __XML:__ Add XML support.

* __Ghostscript:__ Add Ghostscript support.

* __FontsFolder:__ Allows the portable application to support fonts within the directory `..\Data\Fonts`. Any fonts added in this folder will be added and are available for usage during runtime. Be aware, the more fonts to process the longer it will take for the launcher to load and unload these fonts.
> Supported Fonts: 
> - .fon
> - .fnt
> - .ttf
> - .ttc
> - .fot
> - .otf
> - .mmm
> - .pfb
> - .pfm

* __FileCleanup:__ Enable support for adding the section `[FilesCleanup]` in `Launcher.ini`. See `FilesCleanup.nsh` in the Segments directory.
> To use this feature add the section `[FilesCleanup]` to the `Launcher.ini` file. Each entry should be the path to the file that needs deleting. Supports environment variables. Example usage:
> ```INI
> [FilesCleanup]
> 1=%PAL:DataDir%\uselessUpgradeFile.xml
> 2=%APPDATA%\MyProgram\purposelessCfg.ini
> ```

* __DirectoryCleanup:__ Enable support for the sections `[DirectoriesCleanupIfEmpty]` and `[DirectoriesCleanupForce]` in `Launcher.ini`. See `DirectoriesCleanup.nsh` in the Segments directory.

----------

#### __AppInfo.ini__
Added the section `[Team]` for use with code signing and application specifications. New keys are as follows (a short description of what each key means or does can be found further below):
> Note: You should only use the following keys if you need them, otherwise they should be omitted entirely.
```INI
[Team]
Developer=demon.devin
Contributors=DoomStorm
Creator=FukenGruven
CertSigning=true
CertExtension=p12
CertTimestamp=VeriSign
```
* __Developer:__ The name of the developer that created the portable application.

* __Contributors:__ Specify here anyone who has helped with the creation of the portable application.

* __Creator:__ Specify here the original developer of the PAF if you're updating someone else's work.

* __CertSigning:__ If set to true, the `Launcher.exe` will automatically be signed using dual signature hashing algorithm standards (_SHA256_ and _SHA1_). I decided to use dual signing because Windows 8 supports SHA256 Code Signing Certificates (SHA-2 hashing algorithm); whereas, Windows 7 may only support SHA-1 Code Signing Certificates (SHA-1 hashing algorithm). It should be noted that Windows 10 has stopped accepting SHA-1 certificates and certificate chains for Authenticode-signed binaries (unless a timestamp marked the binary as being signed before 1/1/2016). You can visit this [Microsoft Security Advisory article][MSAdvisory] on the availability of SHA-2 code signing support for Windows 7 and Windows Server 2008 R2 for more information about this topic.
>__*ATTENTION:*__ As it is written right now, the `PortableApps.comLauncherGenerator.exe` expects the certificate file to be the developer's name (same as the `[Team]Developer` key's value) and located in `..\Other\Source\Contrib\certificates`. 
> 
> _NOTE_: If your certificate requires you to use a password, refer to lines 741 and 742 and input your password on column 62.
> Be sure it is similar to something like this: `/p "PASSWORD"` where PASSWORD is your password.
* __CertExtension:__ If the key `CertSigning` is set to true then this should be set to the certificate's file extension without the period (e.g. "_pfx_" not "_.pfx_").
* __CertTimestamp:__ Here you can choose which time-stamping service you would like to use. Refer to the table below for a small list of available services and their available hashing algorithms. I would recommend using a service which uses both signature hashes. Be aware that this key is case-sensitive. If this key is omitted, the compiler will default to using _Comodo_.

|       __CertTimestamp__=*`Value`*     	|     __Timestamp Service__    	| __Algorithms__ 	|
|:------------------------	|:----------------------------	|:--------------------	|
| `Comodo`     	| Comodo Group, Inc.           	| _SHA-1_ & _SHA-2_    	|
| `Verisign`   	| Verisign, Inc.               	| _SHA-1_ & _SHA-2_    	|
| `GlobalSign` 	| GMO GlobalSign, Inc.         	| _SHA-1_ & _SHA-2_    	|
| `DigiCert`   	| DigiCert, Inc.               	| _SHA-1_ & _SHA-2_    	|
| `Starfield`  	| Starfield Technologies, LLC. 	| _SHA-1_ & _SHA-2_    	|
| `SwissSign`  	| SwissSign AG                 	| _SHA-2_              	|

I've added several new keys to the `[Dependencies]` section. These newly added keys act like on/off switches to allow support for certain plugins and/or macros/functions (a short description of what each key means or does can be found further below):
> Note: You should only use the following keys if you need them, otherwise they should be omitted entirely.
```INI
[Dependencies]
ElevatedPrivileges=true
UsesJava=true
UsesGhostscript=true
UsesDotNetVersion=4.5
UseStdUtils=true
InstallINF=true
RegistryValueWrite=true
FileWriteReplace=true
FileLocking=true
Firewall=true
Junctions=true
ACLRegSupport=true
ACLDirSupport=true
RMEmptyDir=true
LocalLow=true
PublicDoc=true
CompareVersions=true
ConfigFunctions=true
CloseWindow=true
JSONSupport=true
RestartSleep=500
WinMessages=true
LineWrite=true
TrimString=true
CloseProcess=true
Include64=true
IncludeWordRep=true
GetBetween=true
```
* __ElevatedPrivileges:__ For launchers which need to run with elevated privileges.

* __UsesJava:__ Specifies whether the portable application makes use of [Java Portable][JavaPortable].

* __UsesGhostscript:__ Specifies whether the portable application makes use of [Ghostscript Portable][GhostscriptPortable].

* __UsesDotNetVersion:__ Specify the minimum required version of the .NET framework the portable application needs. Values can be from `1.0` thru `4.7` (*e.g.* `UsesDotNetVersion=1.1` or `UsesDotNetVersion=4.6.2`).

* __UseStdUtils:__ Include the _StdUtils_ plug-in without `ExecAsUser`

* __InstallINF:__ Add support and macros for INF installation. Refer to the `Services.nsh` file in the Segments directory for reference.

* __RegistryValueWrite:__ If you're using `[RegistryValueWrite]` than set this to true otherwise the function is inaccurate.

* __FileWriteReplace:__ Enables the Replace functionality in `[FileWrite]`

* __FileLocking:__ Enable this to prevent ejection/unplugging problems for USB devices. Windows Explorer tend to lock application's DLL(s). 
__Note:__ As of right now, this only enables support for using `${If} ${FileLocked}` and/or `${IfNot} ${FileLocked}` in the `custom.nsh` file. 
__ToDo:__ Handle without the use of `custom.nsh`. (Got a couple ideas already. Check back soon.)

* __Firewall:__ Enable Firewall support.

* __Junctions:__ Enable support for Junctions (_SymLinks_) functionality.

* __ACLRegSupport:__ Enable support for AccessControl on registry keys.

* __ACLDirSupport:__ Enable support for AccessControl on directories.

* __RMEmptyDir:__ Enable the function `RMEmptyDir`. See the `Core.nsh` segment on line 1192 for reference.

* __LocalLow:__ Enable the function `GetLocalAppDataLow`. See the `Core.nsh` segment on line 1351 for reference.

* __PublicDoc:__ Enable the function `GetPublicDoc`. See the `Core.nsh` segment on line 1427 for reference.

* __CompareVersions:__ Enable the function `Compare`. See the `Core.nsh` segment on line 141 for reference.

* __ConfigFunctions:__ Enable `Write(S)` and `Read(S)` functions (4 total). See the `Core.nsh` segment on line 236 for reference.

* __CloseWindow:__ Enable `Close` function. See the `Core.nsh` segment on line 1288 for reference.

* __JSONSupport:__ Include the _nsJSON_ plugin allowing `nsJSON::Get`, `nsJSON::Set`, and `nsJSON::Serialize` for use within `custom.nsh`.

* __RestartSleep:__ Set this to a numerical value (in milliseconds) to set a sleep value for applications that need to restart (i.e. Notepad++ after installing new plugins).

* __WinMessages:__ Include the `WinMessages.nsh` file.

* __LineWrite:__ Include the `LineWrite.nsh` file.

* __TrimString:__ Enable the function `Trim`. See the `Core.nsh` segment on line 1093 for reference.

* __CloseProcess:__ Enable the function `CloseX`. See the `Core.nsh` segment on line 1125 for reference.

* __Include64:__ Include the `64.nsh` file.

* __IncludeWordRep:__ Include both `WordRepS` and `WordRep` functions. See the `Core.nsh` segment on line 608 for reference.

* __GetBetween:__ Include the `GetBetween.nsh` file.

## Documentation
----------

I've begin a small website dedicated to documenting anything I've deemed invaluable in my findings while I've devoted my time to PAFing. You should know that the content you find there is (or will be over time) a collection of help files and guides mostly focused on the making of PAFs. In some circles it's considered the most complete guide to making PAFs with PAL. So I encourage any novice PAFers to give it a visit; you can read up on a wide range of related topics from Registry best-practices to making your own self-signed certificates to sign your PAFs with. 

I've started this because the documentation which is supplied with PAL by PortableApps.com doesn't have, in my humble opinion, any solid information on the power and complexities it's framework has. So I've taken it upon myself to start working on jotting down this unofficial, but my official, guide to making a PAF with PAL. As time has gone by the website has taken on new meaning which now helps developers to better understand the inner workings of the PAL I'm working on here. Not only that but it also goes into great detail in explaining how certain applications and their components are used on a system; which will help you better understand what you're using in this project and why.

Because I am only just one man who has to live outside of my computer, the documentation project (like this project) will take sometime to finish (if ever) so please forgive me on it's incompleteness. This will also serve as a reference/cheat-sheet for those (I know I'll need it, which is partly why I've started it) who need a quick reminder on certain functions and macros for use within the `custom.nsh` file. As an added bonus, all (not yet but most) of the source code I've used here is outlined and better explained/documented there as well. For instance, visit this [page][DocsRegDLL] for a short guide on registering DLLs and all the macros I used to create the `RegisterDLL.nsh` segment. You can visit this [page][DocsServices] for an exhaustive tutorial on dealing with Windows Services; plus it explains what each macro is and does within the `Services.nsh` segment and how to use them in action.

#### __Visit the Docs:__ [The PAF Docs][DocsHome]

## Contributors
----------

This project has been started by [demon.devin][author] and hopefully maintained on a regular basis. However, if you would like to be a part of this then please do not hesitate on getting involved! I'm always open to new ideas and a willingness for the betterment of all things code. =)

Thanks to [zodi](http://compucode.blogspot.com/) for developing the GUI (coming soon).
Thanks to [DoomStorm][TekSpert] for all the suggestions and heavily testing for bugs.

Thank you to the following people; Dave Green (RIP), HandyPAF, all those on the [Discord Workbench][DiscordWorkbench] and anyone else who makes use of this version to *port and let portable!* 

A special thanks to FukenGruven. His codebase was the skeleton which was used to start this project.

----------

=)

[2]: http://portableapps.com/ "PortableApps.com/"
[3]: https://portableapps.com/node/56500 "A Superfluous Discussion"
[4]: https://portableapps.com/apps/development/nsis_portable "NSIS Portable"
[5]: http://johnhaller.com/useful-stuff/dot-net-portable-apps ".NET Availability and Viability With Portable Apps"
[MSAdvisory]: https://support.microsoft.com/en-us/kb/3033929 "MS Security Advisory: SHA2 support for Win7/Windows Server '08 R2: March 10, 2015"
[JavaPortable]: http://portableapps.com/apps/utilities/java_portable "Java Portable"
[GhostscriptPortable]: https://portableapps.com/apps/utilities/ghostscript_portable "Ghostscript Portable"
[DocsRegDLL]: http://softables.tk/docs/advanced/regdll-and-regsrv32 "RegDLL & RegSrv32.exe—DLL Handling"
[DocsServices]: http://softables.tk/docs/advanced/services "A Look into Windows Services"
[DocsHome]: http://softables.tk/docs "The PAF Docs on Softables.tk/"
[author]: http://softables.tk/ "Softables.tk/"
[TekSpert]: http://tekspert.se/ "Webmaster of TekSpert.se/"
[DiscordWorkbench]: https://discord.gg/ExKbgXg "A PAFing Community (Discord Chat Platform)"
