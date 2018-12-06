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
 * @header KMTLinkObject.h
 * @abstract 메시지에서 컨텐츠 영역이나 버튼 클릭 시에 이동되는 링크 정보 오브젝트입니다.
 */

#import <KakaoMessageTemplate/KMTParamObject.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 * @class KMTLinkObject
 * @abstract 메시지에서 컨텐츠 영역이나 버튼 클릭 시에 이동되는 링크 정보 오브젝트입니다.
 * @discussion 오브젝트 내 프로퍼티 중 하나 이상은 반드시 존재해야 합니다. 아무 값도 입력하지 않으면 버튼이 보이지 않거나 클릭 시 이동하지 않을 수 있습니다.<br>
 *             링크에 사용되는 <b>도메인</b>은 반드시 내 애플리케이션 설정에 등록되어야 합니다. 도메인은 개발자 웹사이트의 <b>[내 애플리케이션] - 앱 선택 - [설정] - [일반]</b> 메뉴에서 등록할 수 있습니다.<br>
 *             링크 실행 우선순위는 (android/ios)<b>ExecutionParams > mobileWebURL > webURL</b> 입니다.
 */
@interface KMTLinkObject : KMTParamObject

/*!
 * @property webURL
 * @abstract PC버전 카카오톡에서 사용하는 웹 링크 URL.
 */
@property (copy, nonatomic, nullable) NSURL *webURL;

/*!
 * @property mobileWebURL
 * @abstract 모바일 카카오톡에서 사용하는 웹 링크 URL.
 */
@property (copy, nonatomic, nullable) NSURL *mobileWebURL;

/*!
 * @property androidExecutionParams
 * @abstract Android 카카오톡에서 사용하는 앱 링크 URL에 사용될 파라미터.
 */
@property (copy, nonatomic, nullable) NSString *androidExecutionParams;

/*!
 * @property iosExecutionParams
 * @abstract iOS 카카오톡에서 사용하는 앱 링크 URL에 사용될 파라미터.
 */
@property (copy, nonatomic, nullable) NSString *iosExecutionParams;

@end

@interface KMTLinkBuilder : NSObject

@property (copy, nonatomic, nullable) NSURL *webURL;
@property (copy, nonatomic, nullable) NSURL *mobileWebURL;
@property (copy, nonatomic, nullable) NSString *androidExecutionParams;
@property (copy, nonatomic, nullable) NSString *iosExecutionParams;

- (KMTLinkObject *)build;

@end

@interface KMTLinkObject (ConstructorWithBuilder)

+ (instancetype)linkObjectWithBuilderBlock:(void (^)(KMTLinkBuilder *linkBuilder))builderBlock;
+ (instancetype)linkObjectWithBuilder:(KMTLinkBuilder *)builder;
- (instancetype)initWithBuilder:(KMTLinkBuilder *)builder;

@end

NS_ASSUME_NONNULL_END
