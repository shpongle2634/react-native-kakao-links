# react-native-kakao-links

React-Native Kakao Link Module

### Summary
Forked from https://github.com/trabricks-react/react-native-kakaosdk

It changed below things
 - iOS SDK: 1.23.4
    - note: iOS SDK 1.23.5에는 Xcode 11에서 빌드 에러가 있음
    - podspec을 publish에 포함 - 수동으로 iOS SDK 설정 할 필요 없음
 - Android SDK: 1.30.2
    - change kakao repo url to https
 - Message Template type 정의 

### 필독!

react-native-kakao-plus-friend 와 같이 사용하시는경우 패키지명 중복으로 빌드 에러가 발생할 수 있습니다!
이런 경우 패키지명을 중복하여 읽는 경우가 발생하여 수동으로 패키지명을 바꿔주셔야합니다..!

## Installation

`$ npm install @getmiso/react-native-kakao-link --save`

### React Native Link

#### IOS

카카오링크 공식가이드\
https://developers.kakao.com/docs/latest/ko/getting-started/sdk-ios#legacy

1. info.plist에 
  1. LSApplicationQueriesSchemes 추
  1. Native App Key 등록
1. URL Types에 URL Schemes 추가

#### Android

카카오링크 공식가이드\
https://developers.kakao.com/docs/latest/ko/getting-started/sdk-android#legacy

1. AndroidManifest.xml
  1. Native App Key 추가
  2. intent-filter 추가

## Usage

### Object Type 소개

카카오링크 공식 가이드에 의하면 카카오링크는 몇가지 지정된 템플릿을 이용하여 메시지를 전송하게 됩니다.
템플릿 메시지를 작성하기 위해서는 아래 Object Type을 이용하여 템플릿을 손쉽게 작성할 수 있습니다.
아래 Object Type을 가지고 메시지 템플릿이 어떻게 구성되는지는 다음 섹션을 참조해주세요.

```typescript
type LinkObject = {
  webURL?: string, //optional
  mobileWebURL?: string, //optional
  androidExecutionParams?: string, //optional For Linking URL
  iosExecutionParams?: string //optional For Linking URL
};

type ContentObject = {
  title: string, //required
  link: LinkObject, //required
  imageURL: string, //required

  desc?: string, //optional
  imageWidth?: number, //optional
  imageHeight?: number //optional
};

type SocialObject = {
  likeCount?: number, //optional
  commentCount?: number, //optional
  sharedCount?: number, //optional
  viewCount?: number, //optional
  subscriberCount?: number //optional
};

type ButtonObject = {
  title: string, //required
  link: LinkObject //required
};

type CommerceDetailObject = {
  regularPrice?: number, //required,
  discountPrice?: number, //optional
  discountRate?: number, //optional
  fixedDiscountPrice?: number //optional
};
````

카카오링크 메시지를 전송은 템플릿 종류와 상관없이 `RNKakaoLink.link( options );` 를 사용합니다.
여기서 options는 아래 1~7 의 Template Type을 의미합니다.

전체 샘플코드는 `/examples/TemplateExamples.js` 를 참조해주세요.

**Note** : 공식 문서에는 버튼 이름을 지정하는 buttonTitle 옵션을 지정할 수 있다고 나와있으나 sdk 에서 이를 설정할 수 있는 API가 존재하지 않아 명시하지 않았습니다. buttons 를 이용하시기 바랍니다.

### 1. FeedTemplate

```typescript
type FeedTemplate = {
  objectType: "feed", //required
  content: ContentObject, //required
  social?: SocialObject, //optional
  buttons?: Array<ButtonObject> //optional
};
```

```javascript
export default class TemplateExample extends Component {
  linkFeed = async () => {
    try {
      const options = {
        objectType: "feed", //required
        content: contentObject, //required
        social: socialObject, //optional
        buttons: [buttonObject] //optional
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);
    } catch (e) {
      console.warn(e);
    }
  };

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

```typescript
type ListTemplate = {
  objectType: "list", //required
  headerTitle: string, //required
  headerLink: LinkObject, //required
  contents: Array<ContentObject>, //required
  buttons?: Array<ButtonObject> //optional
};
```

```javascript
export default class TemplateExample extends Component {
  linkList = async () => {
    try {
      const options = {
        objectType: "list", //required
        headerTitle: "리스트 제목", //required
        headerLink: linkObject, //required
        contents: [contentObject, contentObject], //required
        buttons: [buttonObject] //optional
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);
    } catch (e) {
      console.warn(e);
    }
  };

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

```typescript
type LocationTemplate = {
  objectType: "location", //required
  content: ContentObject, //required
  address: string, //required
  addressTitle?: string, //optional
  buttons?: Array<ButtonObject> //optional
};
```

```javascript
export default class TemplateExample extends Component {
  linkLocation = async () => {
    try {
      const options = {
        objectType: "location", //required
        content: contentObject, //required
        address: "실제 주소", //required
        addressTitle: "우리 집", //optional
        buttons: [buttonObject] //optional
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);
    } catch (e) {
      console.warn(e);
    }
  };

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

```typescript
type FeedTemplate = {
  objectType: "feed", //required
  content: ContentObject, //required
  commerce: CommerceObject, //required
  buttons?: Array<ButtonObject> //optional
};
```

```javascript
export default class TemplateExample extends Component {
  linkCommerce = async () => {
    try {
      const options = {
        objectType: "commerce", //required
        content: contentObject, //required
        commerce: commerceDetailObject, //required
        // buttonTitle:'',//optional buttons랑 사용 불가.
        buttons: [buttonObject] //optional
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);
    } catch (e) {
      console.warn(e);
    }
  };

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

```typescript
type TextTemplate = {
  objectType: string, //required
  text: string, //required
  link: LinkObject, //required
  buttons?: Array<ButtonObject> //optional
};
```

```javascript
export default class TemplateExample extends Component {
  linkText = async () => {
    try {
      const options = {
        objectType: "text", //required
        text: "텍스트 입력", //required
        link: linkObject, //required
        // buttonTitle:'',//optional buttons랑 사용 불가.
        buttons: [buttonObject] //optional
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);
    } catch (e) {
      console.warn(e);
    }
  };

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

```typescript
type Scrap = {
  objectType: string, //required
  url: string //required
};
```

```javascript
export default class TemplateExample extends Component {
  linkScrap = async () => {
    try {
      const options = {
        objectType: "scrap", //required
        url: "https://developers.kakao.com" //required
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);
    } catch (e) {
      console.warn(e);
    }
  };

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

```typescript
type CustomTemplate = {
  objectType: "feed", //required
  templateId: string, //required
  templateArgs: any, //required
  buttons?: Array<ButtonObject> //optional
};
```

```javascript
export default class TemplateExample extends Component {
  linkCustom = async () => {
    try {
      const options = {
        objectType: "custom", //required
        templateId: "13671", //required
        templateArgs: {
          title: "커스텀 제목", //Your Param
          desc: "커스텀 설명" //Your Param
        }
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);
    } catch (e) {
      console.warn(e);
    }
  };

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

### FAQ

#### 1. LinkObject 의 webURL / mobileWebURL 파라미터가 동작하지 않는경우.

다음과 같은 시나리오를 원하는 경우 참고하시길 바랍니다.

1.  앱에서 타유저에게 카카오 링크 전송
2.  타유저가 링크 클릭
    2.1 앱 설치시 앱으로 이동.
    2.2 미설치시 마켓 url이 아닌 서비스 홈페이지로 이동

webURL/mobileWebURL 파라미터를 활용하여, 유입 고객을 앱 설치가 아닌
서비스 홈페이지로 유도하고자 한다면,
카카오 콘솔 - 내 애플리케이션에서 웹 플랫폼 추가 후 url에 해당하는 해당하는 도메인을 추가해주셔야 2.2가 정상적으로 동작합니다.
\*\*타 도메인의 웹 URL을 링크하고 싶은 경우 Scrap Template 을 이용하시면 됩니다.
