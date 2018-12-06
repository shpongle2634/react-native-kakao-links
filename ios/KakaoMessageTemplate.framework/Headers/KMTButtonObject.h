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
 * @header KMTButtonObject.h
 * @abstract 메시지 하단에 추가되는 버튼 오브젝트입니다.
 */

#import <KakaoMessageTemplate/KMTParamObject.h>

NS_ASSUME_NONNULL_BEGIN

@class KMTLinkObject;

/*!
 * @class KMTButtonObject
 * @abstract 메시지 하단에 추가되는 버튼 오브젝트입니다.
 */
@interface KMTButtonObject : KMTParamObject

/*!
 * @property title
 * @abstract 버튼의 타이틀
 */
@property (copy, nonatomic) NSString *title;

/*!
 * @property link
 * @abstract 버튼 클릭 시 이동할 링크 정보
 */
@property (copy, nonatomic) KMTLinkObject *link;

@end

@interface KMTButtonObject (Constructor)

+ (instancetype)buttonObjectWithTitle:(NSString *)title link:(KMTLinkObject *)link;
- (instancetype)initWithTitle:(NSString *)title link:(KMTLinkObject *)link;

@end

@interface KMTButtonBuilder : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) KMTLinkObject *link;

- (KMTButtonObject *)build;

@end

@interface KMTButtonObject (ConstructorWithBuilder)

+ (instancetype)buttonObjectWithBuilderBlock:(void (^)(KMTButtonBuilder *buttonBuilder))builderBlock;
+ (instancetype)buttonObjectWithBuilder:(KMTButtonBuilder *)builder;
- (instancetype)initWithBuilder:(KMTButtonBuilder *)builder;

@end

NS_ASSUME_NONNULL_END
