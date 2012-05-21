//
//  FeedObject.h
//  ParseStarterProject
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface FeedObject : NSObject
@property(retain,nonatomic) UIImage* senderImage;
@property(retain,nonatomic) PFObject* pfobj;

@end
