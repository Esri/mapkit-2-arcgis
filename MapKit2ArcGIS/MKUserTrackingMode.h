//
//  MKUserTrackingMode.h
//  Breadcrumb
//
//  Created by Al Pascual on 11/29/12.
//
//

#import <Foundation/Foundation.h>

#if (__IPHONE_5_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED)
enum {
	MKUserTrackingModeNone = 0, // the user's location is not followed
	MKUserTrackingModeFollow, // the map follows the user's location
	MKUserTrackingModeFollowWithHeading, // the map follows the user's location and heading
};
#endif
typedef NSInteger MKUserTrackingMode;