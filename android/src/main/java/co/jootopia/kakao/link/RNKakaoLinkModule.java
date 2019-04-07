
package co.jootopia.kakao.link;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.Promise;

import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.WritableMap;
import com.kakao.kakaolink.v2.KakaoLinkService;
import com.kakao.kakaolink.v2.KakaoLinkResponse;
import com.kakao.message.template.CommerceDetailObject;
import com.kakao.message.template.CommerceTemplate;
import com.kakao.message.template.FeedTemplate;
import com.kakao.message.template.LinkObject;
import com.kakao.message.template.ButtonObject;
import com.kakao.message.template.ListTemplate;
import com.kakao.message.template.LocationTemplate;
import com.kakao.message.template.SocialObject;
import com.kakao.message.template.ContentObject;
import com.kakao.message.template.TemplateParams;
import com.kakao.message.template.TextTemplate;
import com.kakao.network.ErrorResult;
import com.kakao.network.callback.ResponseCallback;
import com.kakao.util.helper.log.Logger;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;


public class RNKakaoLinkModule extends ReactContextBaseJavaModule {

  class BasicResponseCallback<T> extends ResponseCallback<T>{

    private Promise promise;
    public BasicResponseCallback(Promise promise){
      this.promise = promise;
    }

    @Override
    public void onFailure(ErrorResult errorResult) {
      Logger.e(errorResult.toString());
//      Result response = new Result();
//      response.setSuccess(false);
//      response.setResponse(errorResult);
      promise.reject(errorResult.getException());
    }

    @Override
    public void onSuccess(T result) {
      // 템플릿 밸리데이션과 쿼터 체크가 성공적으로 끝남. 톡에서 정상적으로 보내졌는지 보장은 할 수 없다. 전송 성공 유무는 서버콜백 기능을 이용하여야 한다.
      WritableMap map = Arguments.createMap();
      map.putBoolean("success",true);
      KakaoLinkResponse kakaoResponse = (KakaoLinkResponse) result;
      map.putString("argumentMsg",kakaoResponse.getArgumentMsg().toString());
      promise.resolve(map);
    }
  }

  private final ReactApplicationContext reactContext;

  public RNKakaoLinkModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNKakaoLink";
  }


  //Convert ReadableMap to KakaoLink Object.
  private ContentObject createContentObject(ReadableMap content){
    ContentObject.Builder contentObject = ContentObject.newBuilder(
            content.getString("title"),
            content.getString("imageURL"),
            createLinkObject(content.getMap("link"))
    );
    if(content.hasKey("desc")) contentObject.setDescrption(content.getString("desc"));
    if(content.hasKey("imageHeight")) contentObject.setImageHeight(content.getInt("imageHeight"));
    if(content.hasKey("imageWidth")) contentObject .setImageWidth(content.getInt("imageWidth"));

    return contentObject.build();
  }

  private LinkObject createLinkObject(ReadableMap link){
    LinkObject.Builder linkObject = LinkObject.newBuilder();
    if(link.hasKey("webURL")) linkObject.setWebUrl(link.getString("webURL"));
    if(link.hasKey("mobileWebURL")) linkObject.setMobileWebUrl(link.getString("mobileWebURL"));
    if(link.hasKey("androidExecutionParams"))  linkObject.setAndroidExecutionParams(link.getString("androidExecutionParams"));
    if(link.hasKey("iosExecutionParams")) linkObject.setIosExecutionParams(link.getString("iosExecutionParams"));
    return linkObject.build();
  }

  private SocialObject createSocialObject(ReadableMap social){
    SocialObject.Builder socialObject = SocialObject.newBuilder();
    if(social.hasKey("likeCount")) socialObject.setLikeCount( social.getInt("likeCount"));
    if(social.hasKey("commentCount")) socialObject.setCommentCount( social.getInt("commentCount") );
    if(social.hasKey("sharedCount")) socialObject.setSharedCount( social.getInt("sharedCount") );
    if(social.hasKey("subscriberCount")) socialObject.setSubscriberCount(social.getInt("subscriberCount") );
    if(social.hasKey("viewCount")) socialObject.setViewCount( social.getInt("viewCount") );
    return socialObject.build();
  }

  private CommerceDetailObject createCommerceDetailObject(ReadableMap commerce){
    CommerceDetailObject.Builder commerceObject = CommerceDetailObject.newBuilder(
            commerce.getInt("regularPrice")
    );
    if(commerce.hasKey("discountPrice")) commerceObject.setDiscountPrice( commerce.getInt("discountPrice"));
    if(commerce.hasKey("discountRate")) commerceObject.setDiscountRate( commerce.getInt("discountRate"));
    if(commerce.hasKey("fixedDiscountPrice")) commerceObject.setFixedDiscountPrice( commerce.getInt("fixedDiscountPrice"));

    return commerceObject.build();
  }

  //Extract templateArgs Map<String,String>
  private Map<String,String> createTemplateArgsMap(ReadableMap templateArgs){
    Map<String, String> templateArgsMap = new HashMap<>();
    ReadableMapKeySetIterator templateArgsKeys = templateArgs.keySetIterator();
    while(templateArgsKeys.hasNextKey()){
      String key = templateArgsKeys.nextKey();
      String value = templateArgs.getString(key);
      templateArgsMap.put(key,value);
    }
    return templateArgsMap;
  }

  //Extract serverCallbackArgs Map<String,String>
  private Map<String,String> createServerCallbackArgsMap(ReadableMap serverCallbackArgs){
    Map<String, String> serverCallbackArgsMap = new HashMap<>();
    ReadableMapKeySetIterator serverCallbackArgsKeys = serverCallbackArgs.keySetIterator();
    while(serverCallbackArgsKeys.hasNextKey()){
      String key = serverCallbackArgsKeys.nextKey();
      String value = serverCallbackArgs.getString(key);
      serverCallbackArgsMap.put(key,value);
    }
    return serverCallbackArgsMap;
  }

  private ButtonObject createButtonObject(ReadableMap button){
    ButtonObject buttonObject  = new ButtonObject(
            button.getString("title")
            ,createLinkObject(button.getMap("link"))
    );
    return buttonObject;
  }



  //Create Template

  private FeedTemplate createFeedTemplate(ReadableMap options){
    FeedTemplate.Builder feedTemplate = FeedTemplate.newBuilder(
            createContentObject(options.getMap("content"))
    );

    //add Social
    if(options.hasKey("social")) feedTemplate.setSocial( createSocialObject( options.getMap("social") ) );

    //add buttons
    ReadableArray buttons = options.getArray("buttons");
    if(buttons.size()>0){
      for(int i=0; i<buttons.size(); i++){
        feedTemplate.addButton( createButtonObject(buttons.getMap(i)));
      }
    }
    return feedTemplate.build();
  }


  private TextTemplate createTextTemplate(ReadableMap options){
    TextTemplate.Builder textTemplate = TextTemplate.newBuilder(
            options.getString("text"),
            createLinkObject(options.getMap("link"))
    );

    String buttonTitle = options.getString("buttonTitle");
    if(buttonTitle!=null){
      textTemplate.setButtonTitle(options.getString("buttonTitle"));
    }

    //add buttons
    ReadableArray buttons = options.getArray("buttons");
    if(buttons.size()>0){
      for(int i=0; i<buttons.size(); i++){
        textTemplate.addButton( createButtonObject(buttons.getMap(i)));
      }
    }
    return textTemplate.build();

  }


  private LocationTemplate createLocationTemplate(ReadableMap options){
    LocationTemplate.Builder locationTemplate = LocationTemplate.newBuilder(
            options.getString("address"),
            createContentObject(options.getMap("content"))
    );

    String addressTitle = options.getString("addressTitle");
    if(addressTitle!=null){
      locationTemplate.setAddressTitle(options.getString("addressTitle"));
    }
    //add Social
    if(options.hasKey("social")) locationTemplate.setSocial( createSocialObject( options.getMap("social") ) );

    //add buttons
    ReadableArray buttons = options.getArray("buttons");
    if(buttons.size()>0){
      for(int i=0; i<buttons.size(); i++){
        locationTemplate.addButton( createButtonObject(buttons.getMap(i)));
      }
    }
    return locationTemplate.build();

  }


  private ListTemplate createListTemplate(ReadableMap options){

    ListTemplate.Builder listTemplate = ListTemplate.newBuilder(
            options.getString("headerTitle"),
            createLinkObject(options.getMap("headerLink"))
    );

    ReadableArray contents = options.getArray("contents");
    if(contents.size()>1){
      for(int i=0; i<contents.size(); i++){
        listTemplate.addContent( createContentObject(contents.getMap(i)));
      }
    }

    //add buttons
    ReadableArray buttons = options.getArray("buttons");
    if(buttons.size()>0){
      for(int i=0; i<buttons.size(); i++){
        listTemplate.addButton( createButtonObject(buttons.getMap(i)));
      }
    }
    return listTemplate.build();

  }

  private CommerceTemplate createCommerceTemplate(ReadableMap options){
    CommerceTemplate.Builder commerceTemplate = CommerceTemplate.newBuilder(
            createContentObject(options.getMap("content")),
            createCommerceDetailObject(options.getMap("commerce"))
    );

    //add buttons
    ReadableArray buttons = options.getArray("buttons");
    if(buttons.size()>0){
      for(int i=0; i<buttons.size(); i++){
        commerceTemplate.addButton( createButtonObject(buttons.getMap(i)));
      }
    }
    return commerceTemplate.build();
  }


  //sends
  private void sendDefault(TemplateParams params, Promise promise,Map<String,String> serverCallbackArgsMap){
    KakaoLinkService service = KakaoLinkService.getInstance();
    if(serverCallbackArgsMap==null)
      service.sendDefault(this.getCurrentActivity(),params,new BasicResponseCallback<KakaoLinkResponse>(promise));
    else
      service.sendDefault(this.getCurrentActivity(),params,serverCallbackArgsMap, new BasicResponseCallback<KakaoLinkResponse>(promise));
  }

  private void sendCustom(ReadableMap options, Promise promise){
    String templateId = options.getString("templateId");

    ReadableMap templateArgs = options.getMap("templateArgs");
    Map<String,String> templateArgsMap=(templateArgs==null)?null:createTemplateArgsMap(templateArgs);

    ReadableMap serverCallbackArgs = options.getMap("serverCallbackArgs");
    Map<String,String> serverCallbackArgsMap=(serverCallbackArgs==null)?null:createServerCallbackArgsMap(serverCallbackArgs);

    //check serverCallback
    if(serverCallbackArgsMap !=null){//has ServerCallback
      KakaoLinkService.getInstance().sendCustom(this.getCurrentActivity(), templateId, templateArgsMap, serverCallbackArgsMap,new BasicResponseCallback<KakaoLinkResponse>(promise));
    }
    else { //no serverCallback
      KakaoLinkService.getInstance().sendCustom(this.getCurrentActivity(), templateId, templateArgsMap, new BasicResponseCallback<KakaoLinkResponse>(promise));
    }
  }

  private void sendScrap(ReadableMap options, Promise promise){
    String url = options.getString("url");

    String templateId = options.getString("templateId");
    BasicResponseCallback<KakaoLinkResponse> responseCallback =new BasicResponseCallback<>(promise);

    ReadableMap templateArgs = options.getMap("templateArgs");
    Map<String,String> templateArgsMap=(templateArgs==null)?null:createTemplateArgsMap(templateArgs);

    ReadableMap serverCallbackArgs = options.getMap("serverCallbackArgs");
    Map<String,String> serverCallbackArgsMap=(serverCallbackArgs==null)?null:createServerCallbackArgsMap(serverCallbackArgs);

    //!isCustom
    if(templateId ==null){
      if(serverCallbackArgsMap ==null)
        KakaoLinkService.getInstance().sendScrap(this.getCurrentActivity(),url,responseCallback);
      else
        KakaoLinkService.getInstance().sendScrap(this.getCurrentActivity(), url, serverCallbackArgsMap, responseCallback);
    }
    else {//isCustom
      if(serverCallbackArgsMap ==null)
        KakaoLinkService.getInstance().sendScrap(this.getCurrentActivity(), url, templateId, templateArgsMap, responseCallback);
      else
        KakaoLinkService.getInstance().sendScrap(this.getCurrentActivity(), url, templateId, templateArgsMap, serverCallbackArgsMap, responseCallback);
    }
  }


  @ReactMethod
  public void link(final ReadableMap options, final Promise promise) {
    String objectType = options.getString("objectType");
    TemplateParams params = null;
    ReadableMap serverCallbackArgs =null;
    Map<String, String> serverCallbackArgsMap=null;

    if(options.hasKey("serverCallbackArgs")){
      serverCallbackArgs = options.getMap("serverCallbackArgs");
      serverCallbackArgsMap = createServerCallbackArgsMap(serverCallbackArgs);
    }

    switch (objectType) {
      case "feed":
        params = createFeedTemplate(options);
        sendDefault(params, promise, serverCallbackArgsMap);
        break;
      case "text":
        params = createTextTemplate(options);
        sendDefault(params, promise, serverCallbackArgsMap);
        break;
      case "location":
        params = createLocationTemplate(options);
        sendDefault(params, promise, serverCallbackArgsMap);
        break;
      case "list":
        params = createListTemplate(options);
        sendDefault(params, promise, serverCallbackArgsMap);
        break;
      case "commerce":
        params = createCommerceTemplate(options);
        sendDefault(params, promise, serverCallbackArgsMap);
        break;
      case "custom":
        sendCustom(options, promise);
        return;
      case "scrap":
        sendScrap(options, promise);
        return;
      default:
        break;
    }
  }
}
