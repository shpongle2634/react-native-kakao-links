
#import "RNKakaoLink.h"
#import <React/RCTLog.h>

#import <KakaoLink/KakaoLink.h>
#import <KakaoMessageTemplate/KakaoMessageTemplate.h>

@implementation RNKakaoLink

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()


-(KLKTalkLinkSuccessHandler) success:(RCTPromiseResolveBlock)resolve {
    return ^(NSDictionary<NSString *,NSString *> * _Nullable warningMsg, NSDictionary<NSString *,NSString *> * _Nullable argumentMsg) {
    // 성공
//        RCTLogInfo(@"argument message: %@", argumentMsg);
        NSDictionary * response=[NSDictionary dictionaryWithObjectsAndKeys:@"true",@"success",argumentMsg,@"argumentMsg",nil];
        resolve(response);
    };
};

-(KLKTalkLinkFailureHandler) failure:(RCTPromiseRejectBlock)reject
{
    return ^(NSError * _Nonnull error) {
        // 에러
//        RCTLogInfo(@"error message: %@", error);
        reject(@"링크 실패", @"",error);
    };
};

// RCT METOHD

RCT_EXPORT_METHOD(link:(NSDictionary *)options
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
{
    @try{
        KMTTemplate * template=nil;
        NSString * objectType =[options objectForKey:@"objectType"];
        NSDictionary* serverCallbackArgs = [options objectForKey:@"serverCallbackArgs"];
//        RCTLogInfo(@"objectType : %@", objectType);
        
        if([objectType isEqualToString:@"feed"]){
            template = [self createKMTFeedTemplate:options];
            [self sendDefaultWithTemplate:template
                       serverCallbackArgs:serverCallbackArgs
                                 resolver:resolve
                                 rejecter:reject];
        }
        else if([objectType isEqualToString:@"commerce"]){
            template =[self createKMTCommerceTemplate:options];
            [self sendDefaultWithTemplate:template
                       serverCallbackArgs:serverCallbackArgs
                                 resolver:resolve
                                 rejecter:reject];
        }
        else if([objectType isEqualToString:@"list"]){
            template = [self createKMTListTemplate:options];
            [self sendDefaultWithTemplate:template
                       serverCallbackArgs:serverCallbackArgs
                                 resolver:resolve
                                 rejecter:reject];
        }
        else if([objectType isEqualToString:@"location"]){
            template = [self createKMTLocationTemplate:options];
            [self sendDefaultWithTemplate:template
                       serverCallbackArgs:serverCallbackArgs
                                 resolver:resolve
                                 rejecter:reject];
        }else if([objectType isEqualToString:@"text"]){
            template = [self createKMTTextTemplate:options];
            [self sendDefaultWithTemplate:template
                       serverCallbackArgs:serverCallbackArgs
                                 resolver:resolve
                                 rejecter:reject];
        }else if([objectType isEqualToString:@"scrap"]){
            [self sendScrapWithURL:options
                          resolver:resolve
                          rejecter:reject];
        }else if([objectType isEqualToString:@"custom"]){
            [self sendCustomWithTemplateId:options
                          resolver:resolve
                          rejecter:reject];
        }
        
    }
    @catch (NSException * e) {
        reject(@"메시지 템플릿을 확인해주세요.(custom 미지원)", @"Wrong Parameters",NULL);
    }
    
}

//Send Templates
-(void) send: (NSDictionary *) options
resolver: (RCTPromiseResolveBlock)resolve
rejecter: (RCTPromiseRejectBlock)reject
{
    NSString * templateId = [options objectForKey:@"templateId"];
    NSDictionary * templateArgs = [options objectForKey:@"templateArgs"];
    
    [[KLKTalkLinkCenter sharedCenter] sendCustomWithTemplateId:templateId templateArgs:templateArgs
                                                       success: [self success: resolve]
                                                       failure: [self failure: reject]];
}

-(void) sendDefaultWithTemplate : (KMTTemplate *) template
              serverCallbackArgs:(NSDictionary*) serverCallbackArgs
                                resolver: (RCTPromiseResolveBlock)resolve
                                rejecter: (RCTPromiseRejectBlock)reject
{
//        RCTLogInfo(@"template.objectType : %@", template.objectType);
    if(serverCallbackArgs ==nil)
        [[KLKTalkLinkCenter sharedCenter] sendDefaultWithTemplate:template
                                                          success: [self success: resolve]
                                                          failure: [self failure: reject]];
    else
        [[KLKTalkLinkCenter sharedCenter] sendDefaultWithTemplate:template
                                            serverCallbackArgs:serverCallbackArgs
                                                          success: [self success: resolve]
                                                          failure: [self failure: reject]];
}

//Send ScrapWithURL
-(void) sendScrapWithURL : (NSDictionary *) options
                        resolver: (RCTPromiseResolveBlock)resolve
                        rejecter: (RCTPromiseRejectBlock)reject
{
    NSString* url =[[options objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* templateId = [options objectForKey:@"templateId"];
    NSDictionary* templateArgs=[options objectForKey:@"templateArgs"];
    NSDictionary* serverCallbackArgs =[options objectForKey:@"serverCallbackArgs"];
    
    if(templateArgs==nil){
        [[KLKTalkLinkCenter sharedCenter] sendScrapWithURL:[NSURL URLWithString:url]
                                                   success: [self success: resolve]
                                                   failure: [self failure: reject]];
    }
    else{
        if(serverCallbackArgs ==nil)
            [[KLKTalkLinkCenter sharedCenter] sendScrapWithURL:[NSURL URLWithString:url] templateId:templateId
                                                  templateArgs:templateArgs
                                                       success: [self success: resolve]
                                                       failure: [self failure: reject]];
        else
            [[KLKTalkLinkCenter sharedCenter] sendScrapWithURL:[NSURL URLWithString:url]
                                                    templateId:templateId templateArgs:templateArgs
                                            serverCallbackArgs:serverCallbackArgs
                                                       success: [self success: resolve]
                                                       failure: [self failure: reject]];
    }
}


//Send Custom Template
-(void) sendCustomWithTemplateId : (NSDictionary *) options
                 resolver: (RCTPromiseResolveBlock)resolve
                 rejecter: (RCTPromiseRejectBlock)reject
{
    if([options objectForKey:@"serverCallbackArgs"]!= nil){
        [[KLKTalkLinkCenter sharedCenter] sendCustomWithTemplateId:[options objectForKey:@"templateId"]
                                                      templateArgs:[options objectForKey:@"templateArgs"]
                                                serverCallbackArgs:[options objectForKey:@"serverCallbackArgs"]
                                                           success: [self success: resolve]
                                                           failure: [self failure: reject]];
    }
    else{
        [[KLKTalkLinkCenter sharedCenter] sendCustomWithTemplateId:[options objectForKey:@"templateId"]
                                                      templateArgs:[options objectForKey:@"templateArgs"]
                                                           success: [self success: resolve]
                                                           failure: [self failure: reject]];
    }
}


//Create Object

-(KMTContentObject *) createKMTContentObject : (NSDictionary *) content{
    /*
     title          : NSString
     link           : KMTLinkObject
     imageURL       : NSString
     desc?          :NSString
     imageWidth?    :NSNumber
     imageHeight?   :NSNumber
     */
    
    KMTContentObject* contentObject = [KMTContentObject contentObjectWithBuilderBlock:^(KMTContentBuilder * _Nonnull contentBuilder) {
        
        NSString* title =[content objectForKey:@"title"];
        NSString* imageURL =[[content objectForKey:@"imageURL"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        contentBuilder.title = title;
        contentBuilder.link = [self createKMTLinkObject: ([content objectForKey:@"link"])];
        contentBuilder.imageURL = [NSURL URLWithString:imageURL];
        
        if([content objectForKey:@"desc"]!=nil)
            contentBuilder.desc =[content objectForKey:@"desc"];
        if([content objectForKey:@"imageWidth"]!=nil)
            contentBuilder.imageWidth = [content objectForKey:@"imageWidth"];
        if([content objectForKey:@"imageHeight"]!=nil)
            contentBuilder.imageHeight = [content objectForKey:@"imageHeight"];
    }];
//    RCTLogInfo(@"content.title : %@", contentObject.title);
//    RCTLogInfo(@"content.imageURL : %@", contentObject.imageURL.absoluteString);
//    RCTLogInfo(@"content.desc : %@", contentObject.desc);
//    RCTLogInfo(@"content.imageWidth : %@", contentObject.imageWidth);
//    RCTLogInfo(@"content.imageHeight : %@", contentObject.imageHeight);
    return contentObject;
}

-(KMTLinkObject *) createKMTLinkObject : (NSDictionary *) link{
    /*
     webURL?                : NSURL
     mobileWebURL?          : NSURL
     androidExecutionParams?: NSString
     iosExecutionParams?    : NSString
     */
 
    
    KMTLinkObject* linkObject =[KMTLinkObject linkObjectWithBuilderBlock:^(KMTLinkBuilder * _Nonnull linkBuilder) {
        
        NSString* webURL =[[link objectForKey:@"webURL"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* mobileWebURL =[[link objectForKey:@"mobileWebURL"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
       if(webURL!=nil)
           linkBuilder.webURL =[NSURL URLWithString:webURL];
        if(mobileWebURL!=nil)
            linkBuilder.mobileWebURL = [NSURL URLWithString:mobileWebURL];
        if([link objectForKey:@"androidExecutionParams"]!=nil)
            linkBuilder.androidExecutionParams = [link objectForKey:@"androidExecutionParams"];
        if([link objectForKey:@"iosExecutionParams"]!=nil)
            linkBuilder.iosExecutionParams = [link objectForKey:@"iosExecutionParams"];
    }];
//    RCTLogInfo(@"link.webURL : %@", linkObject.webURL);
//    RCTLogInfo(@"link.mobileURL : %@", linkObject.mobileWebURL);
//    RCTLogInfo(@"link.androidExecutionParams : %@", linkObject.androidExecutionParams);
//    RCTLogInfo(@"link.iosExecutionParams : %@", linkObject.iosExecutionParams);

    return linkObject;
}

-(KMTSocialObject *) createKMTSocialObject : (NSDictionary *) social{
    /*
     likeCount?         :NSNumber
     commentCount?      :NSNumber
     sharedCount?       :NSNumber
     viewCount?         :NSNumber
     subscriberCount?   :NSNumber
     */
    KMTSocialObject* socialObject = [KMTSocialObject socialObjectWithBuilderBlock:^(KMTSocialBuilder * _Nonnull socialBuilder) {
        if([social objectForKey:@"likeCount"]!=nil)
            socialBuilder.likeCount = [social objectForKey:@"likeCount"];
        if([social objectForKey:@"commentCount"]!=nil)
            socialBuilder.commnentCount = [social objectForKey:@"commentCount"];// -ㅅ- builder에서 변수이름 틀린듯..
        if([social objectForKey:@"sharedCount"]!=nil)
            socialBuilder.sharedCount = [social objectForKey:@"sharedCount"];
        if([social objectForKey:@"viewCount"]!=nil)
            socialBuilder.viewCount = [social objectForKey:@"viewCount"];
        if([social objectForKey:@"subscriberCount"]!=nil)
            socialBuilder.subscriberCount = [social objectForKey:@"subscriberCount"];
    }];
    return socialObject;
}

-(KMTButtonObject *) createKMTButtonObject : (NSDictionary *) button{
    /*
     title     :NSString
     link      :KMTLinkObject
     */
    
    
    KMTButtonObject * buttonObject = [KMTButtonObject buttonObjectWithBuilderBlock:^(KMTButtonBuilder * _Nonnull buttonBuilder) {
        buttonBuilder.title = [button objectForKey:@"title"];
        buttonBuilder.link = [self createKMTLinkObject:[button objectForKey:@"link"]];
    }];
//    RCTLogInfo(@"button title : %@", buttonObject.title);
//    RCTLogInfo(@"button link : %@", buttonObject.link);
    return buttonObject;
}

-(KMTCommerceObject *) createKMTCommerceObject : (NSDictionary *) commerce{
    /*
     regularPrice           :NSNumber
     discountPrice?         :NSNumber
     discountRate?          :NSNumber
     fixedDiscountPrice?    :NSNumber
     */
    KMTCommerceObject * commerceObject = [KMTCommerceObject commerceObjectWithBuilderBlock:^(KMTCommerceBuilder * _Nonnull commerceBuilder) {
        
        commerceBuilder.regularPrice = [commerce objectForKey:@"regularPrice"];
        if([commerce objectForKey:@"discountPrice"] !=nil)
            commerceBuilder.discountPrice =[commerce objectForKey:@"discountPrice"] ;
        
        if([commerce objectForKey:@"discountRate"] !=nil)
            commerceBuilder.discountRate =[commerce objectForKey:@"discountRate"] ;
        
        if([commerce objectForKey:@"fixedDiscountPrice"] !=nil)
            commerceBuilder.fixedDiscountPrice =[commerce objectForKey:@"fixedDiscountPrice"] ;
        
    }];
    return commerceObject;
}


//Create Template

-(KMTFeedTemplate *) createKMTFeedTemplate : (NSDictionary *) options{
    /*
     objectType     : feed
     content        :KMTContentObject
     social?        :KMTSocialObject
     buttonTitle?   :NSString
     buttons?       :NSArray<KMTButtonObject>
     */
    KMTFeedTemplate * feedTemplate =[KMTFeedTemplate feedTemplateWithBuilderBlock:^(KMTFeedTemplateBuilder * _Nonnull feedTemplateBuilder) {
        
//        RCTLogInfo(@"options : %@", options);
        
        feedTemplateBuilder.content = [self createKMTContentObject : [options objectForKey:@"content"]];
        
        if([options objectForKey:@"social"] != nil)
            feedTemplateBuilder.social = [self createKMTSocialObject:[options objectForKey:@"social"]];
        
        if([options objectForKey:@"buttons"] != nil){
            NSArray * buttons = [options objectForKey:@"buttons"];
            for(NSDictionary * btn in buttons){
                [feedTemplateBuilder addButton:[self createKMTButtonObject:btn]];
            }
        }
    }];
    return feedTemplate;
}


-(KMTCommerceTemplate *) createKMTCommerceTemplate : (NSDictionary *) options{
    /*
     objectType     : commerce
     content        :KMTContentObject
     commerce       :KMTCommerceObject
     buttonTitle?   :NSString
     buttons?       :NSArray<KMTButtonObject>
     */
    KMTCommerceTemplate * commerceTemplate =[KMTCommerceTemplate commerceTemplateWithBuilderBlock:^(KMTCommerceTemplateBuilder * _Nonnull commerceTemplateBuilder) {
        
        commerceTemplateBuilder.content = [self createKMTContentObject : [options objectForKey:@"content"]];
        
        if([options objectForKey:@"commerce"] != nil)
            commerceTemplateBuilder.commerce = [self createKMTCommerceObject:[options objectForKey:@"commerce"]];
        
        if([options objectForKey:@"buttonTitle"] != nil)
            commerceTemplateBuilder.buttonTitle = [options objectForKey:@"buttonTitle"];
        
        if([options objectForKey:@"buttons"] != nil){
            NSArray * buttons = [options objectForKey:@"buttons"];
            for(NSDictionary * btn in buttons){
                [commerceTemplateBuilder addButton:[self createKMTButtonObject:btn]];
            }
        }
    }];
    return commerceTemplate;
}


-(KMTListTemplate *) createKMTListTemplate : (NSDictionary *) options{
    /*
     objectType     : list
     headerTitle    :NSString
     headerLink     :KMTLinkObject
     contents       :NSArray<KMTContentObject>
     buttonTitle?   :NSString
     buttons?       :NSArray<KMTButtonObject>
     */
    KMTListTemplate * listTemplate =[KMTListTemplate listTemplateWithBuilderBlock:^(KMTListTemplateBuilder * _Nonnull listTemplateBuilder) {
        
        listTemplateBuilder.headerTitle = [options objectForKey:@"headerTitle"];
        listTemplateBuilder.headerLink = [self createKMTLinkObject:[options objectForKey:@"headerLink"]];
        
        NSArray * contents = [options objectForKey:@"contents"];
        for(NSDictionary * content in contents){
            [listTemplateBuilder addContent:[self createKMTContentObject:content]];
        }
        
        if([options objectForKey:@"buttonTitle"] != nil)
            listTemplateBuilder.buttonTitle = [options objectForKey:@"buttonTitle"];
        
        if([options objectForKey:@"buttons"] != nil){
            NSArray * buttons = [options objectForKey:@"buttons"];
            for(NSDictionary * btn in buttons){
                [listTemplateBuilder addButton:[self createKMTButtonObject:btn]];
            }
        }
    }];
    return listTemplate;
}


-(KMTLocationTemplate *) createKMTLocationTemplate : (NSDictionary *) options{
    /*
     objectType     : location
     content        :KMTContentObject
     address        :NSString
     addressTitle?  :NSString
     social?        :KMTSocialObject
     buttonTitle?   :NSString
     buttons?       :NSArray<KMTButtonObject>
     */
    KMTLocationTemplate * locationTemplate =[KMTLocationTemplate locationTemplateWithBuilderBlock:^(KMTLocationTemplateBuilder * _Nonnull locationTemplateBuilder) {
        
        locationTemplateBuilder.content = [self createKMTContentObject : [options objectForKey:@"content"]];
        locationTemplateBuilder.address = [options objectForKey:@"address"];
        
        if([options objectForKey:@"addressTitle"] != nil)
            locationTemplateBuilder.addressTitle = [options objectForKey:@"addressTitle"];
        
        if([options objectForKey:@"social"] != nil)
            locationTemplateBuilder.social = [self createKMTSocialObject:[options objectForKey:@"social"]];
        
        if([options objectForKey:@"buttonTitle"] != nil)
            locationTemplateBuilder.buttonTitle = [options objectForKey:@"buttonTitle"];
        
        if([options objectForKey:@"buttons"] != nil){
            NSArray * buttons = [options objectForKey:@"buttons"];
            for(NSDictionary * btn in buttons){
                [locationTemplateBuilder addButton:[self createKMTButtonObject:btn]];
            }
        }
    }];
    return locationTemplate;
}


-(KMTTextTemplate *) createKMTTextTemplate : (NSDictionary *) options{
    /*
     objectType     : text
     text           :NSString
     link           :KMTLinkObject
     buttonTitle?   :NSString
     buttons?       :NSArray<KMTButtonObject>
     */
    KMTTextTemplate * textTemplate =[KMTTextTemplate textTemplateWithBuilderBlock:^(KMTTextTemplateBuilder * _Nonnull textTemplateBuilder) {
        
        textTemplateBuilder.text =[options objectForKey:@"text"];
        textTemplateBuilder.link = [self createKMTLinkObject:[options objectForKey:@"link"]];
      
        if([options objectForKey:@"buttonTitle"] != nil)
            textTemplateBuilder.buttonTitle = [options objectForKey:@"buttonTitle"];
        
        if([options objectForKey:@"buttons"] != nil){
            NSArray * buttons = [options objectForKey:@"buttons"];
            for(NSDictionary * btn in buttons){
                [textTemplateBuilder addButton:[self createKMTButtonObject:btn]];
            }
        }
    }];
    return textTemplate;
}


@end
  
