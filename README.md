# react-native-kakao-links
React-Native Kakao Link Module

### Note

안녕하세요. 술 1병으로 모두가 어깨춤을 추게하는 '꽁알' 서비스를 운영중인 JOOTOPIA입니다.
이번 업데이트에서 카카오 링크 기능이 필요하여 제작하게 되었습니다.
여러분의 빠른 서비스 개발을 응원합니다.

참고하실 사항으로는 react-native-kakao-link 패키지로 만들었는데 npm에 등록이 불가하여 
패키지명을 react-native-kakao-links로 지정하였습니다.
따라서 Android 패키지 및 IOS 패키지 명은 RNKakaoLinks 가 아닌 RNKakaoLink 입니다.
Manual installation시 유의하시기 바랍니다.

## Getting started

`$ npm install react-native-kakao-links --save`


### 빠른 설치
react-native link 를 이용하시면 빠른 설치가 가능합니다.

`$ react-native link react-native-kakao-links`


### 수동 설치
위 react-native link 를 사용하시지 않는 분들은 본 모듈을 IOS, Android에 사용하기위해 아래와 같은 링크 절차를 거쳐야 합니다.

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-kakao-links` and add `RNKakaoLink.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNKakaoLink.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNKakaoLinkPackage;` to the imports at the top of the file
  - Add `new RNKakaoLinkPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-kakao-links'
  	project(':react-native-kakao-links').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-kakao-links/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-kakao-links')
  	```
    
## Install KakaoSDK


#### IOS

//TODO

카카오링크 공식가이드
https://developers.kakao.com/docs/ios/kakaotalk-link 를 참고하셔서 모듈을 사용하기위한 KakaoSDK를 설치하시기 바랍니다.

**Note**: CocoaPod 사용중인 경우 `/ios/Podfile` 에 `pod 'KakaoOpenSDK'`를 추가하고 pod install로 Kakao SDK를 설치할 수 있습니다.


#### Android

//TODO

카카오링크 공식가이드
https://developers.kakao.com/docs/android/kakaotalk-link 를 참고하셔서 모듈을 사용하기위한 KakaoOpenSDK를 설치하시기 바랍니다.

    
## Usage

//TODO

`/examples/TemplateExamples.js` 를 참조해주세요.


