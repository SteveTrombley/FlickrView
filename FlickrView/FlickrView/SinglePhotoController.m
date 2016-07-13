//
//  SinglePhotoController.m
//  FlickrView//
//  Created by Steve Trombley on 9/22/15.
//  Copyright © 2015 Steve Trombley. All rights reserved.
//

#import "SinglePhotoController.h"

@interface SinglePhotoController ()

@property (strong , nonatomic) NSData* imageData;

@end

@implementation SinglePhotoController
@synthesize photo, thePhotoImage, singlePhotoView, activity, imageData;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInvocationOperation *loadPhoto=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadPictureData) object:nil];

    NSInvocationOperation *showPhoto=[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(showPicture) object:nil];
    [showPhoto addDependency:loadPhoto];
    NSOperationQueue *q=[[NSOperationQueue alloc] init];
    [q addOperation:loadPhoto];
    [q addOperation:showPhoto];
}

-(void)loadPictureData {
    imageData=[NSData dataWithContentsOfURL:photo.largeImageUrl];
 }

-(void)showPicture {
    thePhotoImage=[UIImage imageWithData:imageData];
    singlePhotoView.image=thePhotoImage;
    [activity stopAnimating];
    [UIView animateWithDuration:.5 animations:^ { singlePhotoView.alpha=1;}];

}

-(IBAction)Done {
    [self dismissViewControllerAnimated:YES completion:nil];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
