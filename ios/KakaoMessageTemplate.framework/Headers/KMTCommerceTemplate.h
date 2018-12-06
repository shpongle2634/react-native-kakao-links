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
 * @header KMTCommerceTemplate.h
 * @abstract 기본 템플릿으로 제공되는 커머스 템플릿 클래스.
 */

#import <KakaoMessageTemplate/KMTTemplate.h>

NS_ASSUME_NONNULL_BEGIN

@class KMTContentObject;
@class KMTCommerceObject;
@class KMTLinkObject;
@class KMTButtonObject;

/*!
 * @class KMTCommerceTemplate
 * @abstract 기본 템플릿으로 제공되는 커머스 템플릿 클래스.
 * @discussion 커머스 템플릿은 하나의 컨텐츠와 하나의 커머스 정보, 하나의 기본 버튼을 가집니다. 임의의 버튼을 최대 2개까지 설정할 수 있습니다.
 */
@interface KMTCommerceTemplate : KMTTemplate

/*!
 * @property content
 * @abstract 메시지의 메인 컨텐츠 정보.
 */
@property (copy, nonatomic) KMTContentObject *content;

/*!
 * @property commerce
 * @abstract 컨텐츠에 대한 가격 정보.
 */
@property (copy, nonatomic) KMTCommerceObject *commerce;

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

@interface KMTCommerceTemplate (Constructor)

+ (instancetype)commerceTemplateWithContent:(KMTContentObject *)content commerce:(KMTCommerceObject *)commerce;
- (instancetype)initWithContent:(KMTContentObject *)content commerce:(KMTCommerceObject *)commerce;

@end

@interface KMTCommerceTemplateBuilder : NSObject

@property (copy, nonatomic) KMTContentObject *content;
@property (copy, nonatomic) KMTCommerceObject *commerce;
@property (copy, nonatomic, nullable) NSString *buttonTitle;
@property (copy, nonatomic, nullable) NSMutableArray<KMTButtonObject *> *buttons;

- (void)addButton:(KMTButtonObject *)button;
- (KMTCommerceTemplate *)build;

@end

@interface KMTCommerceTemplate (ConstructorWithBuilder)

+ (instancetype)commerceTemplateWithBuilderBlock:(void (^)(KMTCommerceTemplateBuilder *commerceTemplateBuilder))builderBlock;
+ (instancetype)commerceTemplateWithBuilder:(KMTCommerceTemplateBuilder *)builder;
- (instancetype)initWithBuilder:(KMTCommerceTemplateBuilder *)builder;

@end

NS_ASSUME_NONNULL_END
