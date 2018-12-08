# react-native-kakao-links
React-Native Kakao Link Module

### Note

안녕하세요. 술 1병으로 모두가 어깨춤을 추게하는 '꽁알' 서비스를 준비중인 JOOTOPIA입니다.
RN으로 서비스를 개발하는 중 카카오링크 기능이 필요하여 본 모듈을 제작하게 되었습니다.

지원하지 않는 기능 및 오류가 있으시면 이슈란에 남겨주시기 바랍니다.

참고하실 사항으로는 본래 패키지 이름을 react-native-kakao-link 패키지로 하고싶었으나
npm에 등록이 불가하여 패키지명을 react-native-kakao-links로 지정하였습니다.
그러한 흔적(?)으로 Android 패키지 및 IOS 패키지 명은 RNKakaoLinks 가 아닌 RNKakaoLink 입니다. Manual installation 및 사용시 유의하시기 바랍니다.

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

카카오링크 공식가이드
https://developers.kakao.com/docs/ios/kakaotalk-link 를 참고하셔서 모듈을 사용하기위한 KakaoSDK를 설치하시기 바랍니다.

**Note**: CocoaPod 사용중인 경우 `/ios/Podfile` 에 `pod 'KakaoOpenSDK'`를 추가하고 pod install로 Kakao SDK를 설치할 수 있습니다.


#### Android

카카오링크 공식가이드
https://developers.kakao.com/docs/android/kakaotalk-link 를 참고하셔서 모듈을 사용하기위한 Kakao SDK를 설치하시기 바랍니다.



## Usage

### Object Type 소개

카카오링크 공식 가이드에 의하면 카카오링크는 몇가지 지정된 템플릿을 이용하여 메시지를 전송하게 됩니다.
템플릿 메시지를 작성하기 위해서는 아래 Object Type을 이용하여 템플릿을 손쉽게 작성할 수 있습니다.
아래 Object Type을 가지고 메시지 템플릿이 어떻게 구성되는지는 다음 섹션을 참조해주세요.

```javascript
type LinkObject={
    webURL?                :string, //optional
    mobileWebURL?          :string, //optional
    androidExecutionParams?:string, //optional For Linking URL
    iosExecutionParams?    :string, //optional For Linking URL
};


type ContentObject = {
  title     : string,     //required
  link      : LinkObject, //required
  imageURL  : string,     //required

  desc?       : string,   //optional
  imageWidth? : number,   //optional
  imageHeight?:number     //optional
}

type SocialObject ={
  likeCount?        :number,//optional
  commentCount?     :number,//optional
  sharedCount?      :number,//optional
  viewCount?        :number,//optional
  subscriberCount?  :number//optional
}

type ButtonObject = {
  title : string,//required
  link  : LinkObject,//required
}

type CommerceDetailObject ={
  regularPrice?       :number,  //required,
  discountPrice?      :number,  //optional
  discountRate?       :number,  //optional
  fixedDiscountPrice? :number   //optional
};
```

카카오링크 메시지를 전송은 템플릿 종류와 상관없이 `RNKakaoLink.link( options );` 를 사용합니다.
여기서 options는 아래 1~7 의 Template Type을 의미합니다.

전체 샘플코드는 `/examples/TemplateExamples.js` 를 참조해주세요.

**Note** : 공식 문서에는 버튼 이름을 지정하는 buttonTitle 옵션을 지정할 수 있다고 나와있으나 sdk 에서 이를 설정할 수 있는 API가 존재하지 않아 명시하지 않았습니다. buttons 를 이용하시기 바랍니다.

### 1. FeedTemplate
```javascript
type FeedTemplate = {
        objectType    : 'feed',             //required
        content       : ContentObject,      //required
        social?       : SocialObject,       //optional
        buttons?      : Array<ButtonObject> //optional
 };
```

```javascript
export default class TemplateExample extends Component {

  linkFeed = async () => {
    try{
      const options = {
        objectType:'feed',//required
        content:contentObject,//required
        social:socialObject,//optional
        buttons:[buttonObject]//optional
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);

    }catch(e){
      console.warn(e);
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <TouchableOpacity onPress={this.linkFeed} style={styles.button}>
          <Text style={styles.buttonText}>Feed</Text>
        </TouchableOpacity>
      </View>
    );
  }
}
```


### 2. ListTemplate
```javascript
type ListTemplate = {
        objectType    :'list',                //required
        headerTitle   : string,               //required
        headerLink    : LinkObject,           //required
        contents      : Array<ContentObject>, //required
        buttons?      : Array<ButtonObject>   //optional
 };
```

```javascript
export default class TemplateExample extends Component {

  linkList = async () => {
    try{
      const options = {
        objectType:'list',//required
        headerTitle:'리스트 제목',//required
        headerLink:linkObject,//required
        contents:[contentObject,contentObject],//required
        buttons:[buttonObject]//optional
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);
    }catch(e){
      console.warn(e);
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <TouchableOpacity onPress={this.linkList} style={styles.button}>
          <Text style={styles.buttonText}>List</Text>
        </TouchableOpacity>
      </View>
    );
  }
}
```

#### 3. LocationTemplate
```javascript
type LocationTemplate = {
        objectType    :'location',          //required
        content       : ContentObject,      //required
        address       : string,             //required
        addressTitle? : string,             //optional
        buttons?      : Array<ButtonObject> //optional
 };
```

```javascript
export default class TemplateExample extends Component {

  linkLocation = async () => {
    try{
      const options = {
        objectType:'location',//required
        content:contentObject,//required
        address:'실제 주소',//required
        addressTitle:'우리 집',//optional
        buttons:[buttonObject]//optional
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);
    }catch(e){
      console.warn(e);
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <TouchableOpacity onPress={this.linkLocation} style={styles.button}>
          <Text style={styles.buttonText}>Location</Text>
        </TouchableOpacity>
      </View>
    );
  }
}
```


### 4. CommerceTemplate
```javascript
type FeedTemplate = {
        objectType    : 'feed',             //required
        content       : ContentObject,      //required
        commerce      : CommerceObject,     //required
        buttons?      : Array<ButtonObject> //optional
 };
```
```javascript
export default class TemplateExample extends Component {

  linkCommerce = async () => {
    try{
      const options = {
        objectType:'commerce',//required
        content:contentObject,//required
        commerce:commerceDetailObject,//required
        // buttonTitle:'',//optional buttons랑 사용 불가.
        buttons:[buttonObject]//optional
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);
    }catch(e){
      console.warn(e);
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <TouchableOpacity onPress={this.linkCommerce} style={styles.button}>
          <Text style={styles.buttonText}>Commerce</Text>
        </TouchableOpacity>
      </View>
    );
  }
}
```

### 5. TextTemplate
```javascript
type TextTemplate = {
        objectType  : string,  //required
        text        : string,  //required
        link        : LinkObject,//required
        buttons?    : Array<ButtonObject>//optional
};
```

```javascript
export default class TemplateExample extends Component {

  linkText = async () => {
    try{
      const options = {
        objectType:'text',//required
        text:'텍스트 입력',//required
        link:linkObject,//required
        // buttonTitle:'',//optional buttons랑 사용 불가.
        buttons:[buttonObject]//optional
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);
    }catch(e){
      console.warn(e);
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <TouchableOpacity onPress={this.linkText} style={styles.button}>
          <Text style={styles.buttonText}>Text</Text>
        </TouchableOpacity>
      </View>
    );
  }
}
```

### 6. Scrap
```javascript
type Scrap = {
        objectType  : string,  //required
        url         : string,  //required
};
```

```javascript
export default class TemplateExample extends Component {

  linkScrap = async () => {
    try{
      const options = {
        objectType:'scrap',//required
        url:'https://developers.kakao.com',//required
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);
    }catch(e){
      console.warn(e);
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <TouchableOpacity onPress={this.linkScrap} style={styles.button}>
          <Text style={styles.buttonText}>Scrap</Text>
        </TouchableOpacity>
      </View>
    );
  }
}
```

### 7. Custom
```javascript
type CustomTemplate = {
        objectType    : 'feed',             //required
        templateId    : string,             //required
        templateArgs  : any,                //required
        buttons?      : Array<ButtonObject> //optional
 };
```
```javascript
export default class TemplateExample extends Component {

  linkCustom = async () => {
    try{
      const options = {
        objectType:'custom',//required
        templateId:'13671',//required
        templateArgs:{
          title:'커스텀 제목',//Your Param
          desc:'커스텀 설명',//Your Param
        }
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);
    }catch(e){
      console.warn(e);
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <TouchableOpacity onPress={this.linkCustom} style={styles.button}>
          <Text style={styles.buttonText}>Custom</Text>
        </TouchableOpacity>
      </View>
    );
  }
}
```
## TODO

#### Callback
#### 카카오스토리 링크
