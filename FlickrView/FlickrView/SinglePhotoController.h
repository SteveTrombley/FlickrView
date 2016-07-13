//
//  SinglePhotoController.h
//  WHOOP
//
//  Created by Steve Trombley on 9/22/15.
//  Copyright © 2015 Steve Trombley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface SinglePhotoController : UIViewController

@property (weak , nonatomic) IBOutlet UIImageView *singlePhotoView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong , nonatomic) UIImage *thePhotoImage;
@property (strong , nonatomic) Photo *photo;

@end
