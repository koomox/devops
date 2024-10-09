# Android SDK Tools       
很久没有使用 Android SDK Tools 工具了，下载了最新的 SDK Tools 26.1.1 版本，发现已经没有了 GUI 界面，只有命令行。        
Android Studio 最新版支持JDK 9，Oracle 官网只有8和10，安装了 JDK 8，设置好环境变量。            
把 `sdk-tools-windows-4333796.zip` 解压到 `\Android\SDK` 目录下。         
```sh
@echo off
cmd /k cd /d G:\Android\SDK\tools\bin
echo ..
```
设置 Android SDK 根目录       
```sh
sdkmanager --sdk_root=G:\Android\SDK --channel=0 --verbose
```
帮助          
```sh
sdkmanager --list [options]
```
查看 SDK 已安装包和未安装包          
```sh
sdkmanager --list
```
安装 Android SDK          
```sh
sdkmanager "platform-tools" "platforms;android-26"
sdkmanager "platforms;android-27"
sdkmanager "platforms;android-28"
```
```sh
sdkmanager "build-tools;26.0.3"
sdkmanager "build-tools;27.0.3"
sdkmanager "build-tools;28.0.2"
```
更新 Android SDK        
```sh
sdkmanager --update
```
安装 Intel HAXM  
```sh
sdkmanager "extras;intel;Hardware_Accelerated_Execution_Manager"
```
安装 Android 镜像         
```sh
sdkmanager "sysetm-images;android-28;default;x86"
sdkmanager "sysetm-images;android-28;default;x86_64"
```
提示找不到 `repositories.cfg` 文件，创建一个就可以了。        
```sh
echo "" > %USERPROFILE%\.android\repositories.cfg
```