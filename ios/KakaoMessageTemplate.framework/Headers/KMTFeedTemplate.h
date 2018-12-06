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
 * @header KMTFeedTemplate.h
 * @abstract 기본 템플릿으로 제공되는 피드 템플릿 클래스.
 */

#import <KakaoMessageTemplate/KMTTemplate.h>

NS_ASSUME_NONNULL_BEGIN

@class KMTContentObject;
@class KMTSocialObject;
@class KMTLinkObject;
@class KMTButtonObject;

/*!
 * @class KMTFeedTemplate
 * @abstract 기본 템플릿으로 제공되는 피드 템플릿 클래스.
 * @discussion 피드 템플릿은 하나의 컨텐츠와 하나의 기본 버튼을 가집니다. 소셜 정보를 추가할 수 있으며 임의의 버튼을 설정할 수도 있습니다.
 */
@interface KMTFeedTemplate : KMTTemplate

/*!
 * @property content
 * @abstract 메시지의 메인 컨텐츠 정보.
 */
@property (copy, nonatomic) KMTContentObject *content;

/*!
 * @property social
 * @abstract 컨텐츠에 대한 소셜 정보.
 */
@property (copy, nonatomic, nullable) KMTSocialObject *social;

/*!
 * @property buttonTitle
 * @abstract 기본 버튼 타이틀("자세히 보기")을 변경하고 싶을 때 설정.
 */
@property (copy, nonatomic, nullable) NSString *buttonTitle;

/*!
 * @property buttons
 * @abstract 버튼 목록. 버튼 타이틀과 링크를 변경하고 싶을때, 버튼 두개를 사용하고 싶을때 사용. (최대 2개)
 */
@property (copy, nonatomic, nullable) NSArray<KMTButtonObject *> *buttons;

@end

@interface KMTFeedTemplate (Constructor)

+ (instancetype)feedTemplateWithContent:(KMTContentObject *)content;
- (instancetype)initWithContent:(KMTContentObject *)content;

@end

@interface KMTFeedTemplateBuilder : NSObject

@property (copy, nonatomic) KMTContentObject *content;
@property (copy, nonatomic, nullable) KMTSocialObject *social;
@property (copy, nonatomic, nullable) NSString *buttonTitle;
@property (copy, nonatomic, nullable) NSMutableArray<KMTButtonObject *> *buttons;

- (void)addButton:(KMTButtonObject *)button;
- (KMTFeedTemplate *)build;

@end

@interface KMTFeedTemplate (ConstructorWithBuilder)

+ (instancetype)feedTemplateWithBuilderBlock:(void (^)(KMTFeedTemplateBuilder *feedTemplateBuilder))builderBlock;
+ (instancetype)feedTemplateWithBuilder:(KMTFeedTemplateBuilder *)builder;
- (instancetype)initWithBuilder:(KMTFeedTemplateBuilder *)builder;

@end

NS_ASSUME_NONNULL_END
