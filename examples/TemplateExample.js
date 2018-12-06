import React, { Component } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
} from 'react-native';
import RNKakaoLink from 'react-native-kakao-link';


const linkObject={
    webURL                :'https://developers.kakao.com/docs/android/kakaotalk-link',//optional
    mobileWebURL          :'https://developers.kakao.com/docs/android/kakaotalk-link',//optional
    androidExecutionParams:'shopId=1&itemId=24', //optional For Linking URL
    iosExecutionParams    :'shopId=1&itemId=24', //optional For Linking URL
};


const contentObject = {
  title     : '제목',
  link      : linkObject,
  imageURL  : 'http://mud-kage.kakao.co.kr/dn/NTmhS/btqfEUdFAUf/FjKzkZsnoeE4o19klTOVI1/openlink_640x640s.jpg',

  desc      : '설명',//optional
  imageWidth: 240,//optional
  imageHeight:240//optional
}

//5개의 속성 중 최대 3개만 표시해 줍니다. 우선순위는 Like > Comment > Shared > View > Subscriber 입니다.
const socialObject ={
  likeCount:12,//optional
  commentCount:1,//optional
  sharedCount:23,//optional
  viewCount:10,//optional
  subscriberCount:22//optional
}

const buttonObject = {
  title:'앱으로보기',
  link : linkObject,
}


const commerceDetailObject ={
  regularPrice :10000,//required,
  // discountPrice:1000,//Optional
  // discountRate:10,//Optional
  // fixedDiscountPrice:1000//Optional
};


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

  linkLocation = async () => {
    try{
      const options = {
        objectType:'location',//required
        content:contentObject,//required
        address:'실제 주소',//required
        addressTitle:'우리 집',//optional
        // buttonTitle:'',//optional buttons랑 사용 불가.
        buttons:[buttonObject]//optional
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);
    }catch(e){
      console.warn(e);
    }
  }

  linkList = async () => {
    try{
      const options = {
        objectType:'list',//required
        headerTitle:'리스트 제목',//required
        headerLink:linkObject,//required
        contents:[contentObject,contentObject],//required
        // buttonTitle:'',//optional buttons랑 사용 불가.
        buttons:[buttonObject]//optional
      };
      const response = await RNKakaoLink.link(options);
      console.log(response);
    }catch(e){
      console.warn(e);
    }
  }


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

        <TouchableOpacity onPress={this.linkList} style={styles.button}>
          <Text style={styles.buttonText}>List</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={this.linkLocation} style={styles.button}>
          <Text style={styles.buttonText}>Location</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={this.linkCommerce} style={styles.button}>
          <Text style={styles.buttonText}>Commerce</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={this.linkText} style={styles.button}>
          <Text style={styles.buttonText}>Text</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={this.linkScrap} style={styles.button}>
          <Text style={styles.buttonText}>Scrap</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={this.linkCustom} style={styles.button}>
          <Text style={styles.buttonText}>Custom</Text>
        </TouchableOpacity>

      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  button:{
    width: 240,
    height:48,
    backgroundColor: "#afafaf",
    borderWidth:1,
    borderRadius: 24,
    justifyContent: 'center',
    marginVertical: 10,
  },
  buttonText:{
    textAlign: 'center',
  }
});
