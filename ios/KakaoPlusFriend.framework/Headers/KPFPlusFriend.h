/**
 * Copyright 2018 Kakao Corp.
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
 * @header KPFPlusFriend.h
 * @abstract 카카오톡 플러스친구 연동 기능을 제공합니다.
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 * @class KPFPlusFriend
 * @abstract 카카오톡 플러스친구 연동 기능을 제공하는 클래스입니다.
 */
@interface KPFPlusFriend : NSObject

/*!
 * @property Id
 * @abstract 플러스친구 ID
 * @discussion 플러스친구 홈 URL에 들어간 {_영문}으로 구성된 고유 ID를 입력해주세요. 홈 URL은 플러스친구 관리자센터 > 관리 > 상세설정 페이지에서 확인할 수 있습니다.
 */
@property (readonly) NSString *Id;

- (instancetype)initWithId:(NSString *)Id;

/*!
 * @method addFriend
 * @abstract 친구 추가 기능을 실행합니다.
 * @discussion addFriendURL을 이용하여 사파리 뷰컨트롤러에 브릿지 페이지를 로딩합니다. 페이지 로딩이 완료되면 해당 플러스친구를 추가할 수 있는 카카오톡 커스텀 스킴을 실행합니다.
 */
- (BOOL)addFriend;
/*!
 * @method chat
 * @abstract 1:1 채팅 기능을 실행합니다.
 * @discussion chatURL을 이용하여 사파리 뷰컨트롤러에 브릿지 페이지를 로딩합니다. 페이지 로딩이 완료되면 해당 플러스친구와 1:1 채팅할 수 있는 카카오톡 커스텀 스킴을 실행합니다.
 */
- (BOOL)chat;

/*!
 * @method addFriendURL
 * @abstract 친구 추가 기능을 위한 브릿지 페이지 URL을 반환합니다.
 */
- (NSURL *)addFriendURL;
/*!
 * @method chatURL
 * @abstract 1:1 채팅 기능을 위한 브릿지 페이지 URL을 반환합니다.
 */
- (NSURL *)chatURL;

@end

NS_ASSUME_NONNULL_END
