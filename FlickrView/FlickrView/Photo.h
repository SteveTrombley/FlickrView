//
//  FlickrPhoto.h
//  Flickr Search
//
//  Created by Steve Trombley
//  Copyright (c) 2015 Steve Trombley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject


@property (strong, nonatomic) UIImage *thumbnail;
@property (strong, nonatomic) UIImage *largeImage;
@property (strong, nonatomic) NSURL   *thumbnailUrl;
@property (strong, nonatomic) NSURL   *largeImageUrl;
@property (nonatomic, readonly) BOOL hasImage;
@property (nonatomic, getter = isFailed) BOOL failed;

@end
