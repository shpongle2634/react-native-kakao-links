/**
 * Copyright 2017-2018 Kakao Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/*!
 * @header KMTLocationTemplate.h
 * @abstract 주소를 이용하여 특정 위치를 공유할 수 있는 메시지 템플릿입니다.
 */

#import <KakaoMessageTemplate/KMTTemplate.h>

NS_ASSUME_NONNULL_BEGIN

@class KMTContentObject;
@class KMTSocialObject;
@class KMTLinkObject;
@class KMTButtonObject;

/*!
 * @class KMTLocationTemplate
 * @abstract 주소를 이용하여 특정 위치를 공유할 수 있는 메시지 템플릿입니다.
 * @discussion 위치 템플릿은 지도 표시에 사용되는 주소 정보와 해당 위치를 설명할 수 있는 컨텐츠 오브젝트로 구성됩니다. 왼쪽 하단에 기본 버튼, 오른쪽 하단에 지도를 보여주기 위한 "위치 보기" 버튼이 추가됩니다. "위치 보기" 버튼을 클릭하면 카카오톡 채팅방 내에서 바로 지도 화면으로 전환하여 해당 주소의 위치를 확인할 수 있습니다.
 */
@interface KMTLocationTemplate : KMTTemplate

/*!
 * @property address
 * @abstract 공유할 위치의 주소. 예) 경기 성남시 분당구 판교역로 235
 */
@property (copy, nonatomic) NSString *address;

/*!
 * @property addressTitle
 * @abstract 카카오톡 내의 지도 뷰에서 사용되는 타이틀. 예) 카카오판교오피스
 */
@property (copy, nonatomic, nullable) NSString *addressTitle;

/*!
 * @property content
 * @abstract 위치에 대해 설명하는 컨텐츠 정보.
 */
@property (copy, nonatomic) KMTContentObject *content;

/*!
 * @property social
 * @abstract 부가적인 소셜 정보.
 */
@property (copy, nonatomic, nullable) KMTSocialObject *social;

/*!
 * @property buttonTitle
 * @abstract 기본 버튼 타이틀("자세히 보기")을 변경하고 싶을 때 설정.
 */
@property (copy, nonatomic, nullable) NSString *buttonTitle;

/*!
 * @property buttons
 * @abstract 버튼 목록. 기본 버튼의 타이틀 외에 링크도 변경하고 싶을 때 설정. (최대 1개, 오른쪽 "위치 보기" 버튼은 고정)
 */
@property (copy, nonatomic, nullable) NSArray<KMTButtonObject *> *buttons;

@end

@interface KMTLocationTemplate (Constructor)

+ (instancetype)locationTemplateWithAddress:(NSString *)address content:(KMTContentObject *)content;
- (instancetype)initWithAddress:(NSString *)address content:(KMTContentObject *)content;

@end

@interface KMTLocationTemplateBuilder : NSObject

@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic, nullable) NSString *addressTitle;
@property (copy, nonatomic) KMTContentObject *content;
@property (copy, nonatomic, nullable) KMTSocialObject *social;
@property (copy, nonatomic, nullable) NSString *buttonTitle;
@property (copy, nonatomic, nullable) NSMutableArray<KMTButtonObject *> *buttons;

- (void)addButton:(KMTButtonObject *)button;
- (KMTLocationTemplate *)build;

@end

@interface KMTLocationTemplate (ConstructorWithBuilder)

+ (instancetype)locationTemplateWithBuilderBlock:(void (^)(KMTLocationTemplateBuilder *locationTemplateBuilder))builderBlock;
+ (instancetype)locationTemplateWithBuilder:(KMTLocationTemplateBuilder *)builder;
- (instancetype)initWithBuilder:(KMTLocationTemplateBuilder *)builder;

@end

NS_ASSUME_NONNULL_END
