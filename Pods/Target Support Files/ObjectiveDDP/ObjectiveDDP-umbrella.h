#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BSONIdGenerator.h"
#import "DependencyProvider.h"
#import "MeteorClient+Private.h"
#import "MeteorClient.h"
#import "ObjectiveDDP.h"

FOUNDATION_EXPORT double ObjectiveDDPVersionNumber;
FOUNDATION_EXPORT const unsigned char ObjectiveDDPVersionString[];

