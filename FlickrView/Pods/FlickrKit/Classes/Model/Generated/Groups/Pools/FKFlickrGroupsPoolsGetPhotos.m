//
//  FKFlickrGroupsPoolsGetPhotos.m
//  FlickrKit
//
//  Generated by FKAPIBuilder.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrGroupsPoolsGetPhotos.h" 

@implementation FKFlickrGroupsPoolsGetPhotos



- (BOOL) needsLogin {
    return NO;
}

- (BOOL) needsSigning {
    return NO;
}

- (FKPermission) requiredPerms {
    return -1;
}

- (NSString *) name {
    return @"flickr.groups.pools.getPhotos";
}

- (BOOL) isValid:(NSError **)error {
    BOOL valid = YES;
	NSMutableString *errorDescription = [[NSMutableString alloc] initWithString:@"You are missing required params: "];
	if(!self.group_id) {
		valid = NO;
		[errorDescription appendString:@"'group_id', "];
	}

	if(error != NULL) {
		if(!valid) {	
			NSDictionary *userInfo = @{NSLocalizedDescriptionKey: errorDescription};
			*error = [NSError errorWithDomain:FKFlickrKitErrorDomain code:FKErrorInvalidArgs userInfo:userInfo];
		}
	}
    return valid;
}

- (NSDictionary *) args {
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
	if(self.group_id) {
		[args setValue:self.group_id forKey:@"group_id"];
	}
	if(self.tags) {
		[args setValue:self.tags forKey:@"tags"];
	}
	if(self.user_id) {
		[args setValue:self.user_id forKey:@"user_id"];
	}
	if(self.extras) {
		[args setValue:self.extras forKey:@"extras"];
	}
	if(self.per_page) {
		[args setValue:self.per_page forKey:@"per_page"];
	}
	if(self.page) {
		[args setValue:self.page forKey:@"page"];
	}

    return [args copy];
}

- (NSString *) descriptionForError:(NSInteger)error {
    switch(error) {
		case FKFlickrGroupsPoolsGetPhotosError_GroupNotFound:
			return @"Group not found";
		case FKFlickrGroupsPoolsGetPhotosError_YouDontHavePermissionToViewThisPool:
			return @"You don't have permission to view this pool";
		case FKFlickrGroupsPoolsGetPhotosError_UnknownUser:
			return @"Unknown user";
		case FKFlickrGroupsPoolsGetPhotosError_GroupOrpoolIsMemberOnly:
			return @"Group/pool is member only";
		case FKFlickrGroupsPoolsGetPhotosError_InvalidAPIKey:
			return @"Invalid API Key";
		case FKFlickrGroupsPoolsGetPhotosError_ServiceCurrentlyUnavailable:
			return @"Service currently unavailable";
		case FKFlickrGroupsPoolsGetPhotosError_WriteOperationFailed:
			return @"Write operation failed";
		case FKFlickrGroupsPoolsGetPhotosError_FormatXXXNotFound:
			return @"Format \"xxx\" not found";
		case FKFlickrGroupsPoolsGetPhotosError_MethodXXXNotFound:
			return @"Method \"xxx\" not found";
		case FKFlickrGroupsPoolsGetPhotosError_InvalidSOAPEnvelope:
			return @"Invalid SOAP envelope";
		case FKFlickrGroupsPoolsGetPhotosError_InvalidXMLRPCMethodCall:
			return @"Invalid XML-RPC Method Call";
		case FKFlickrGroupsPoolsGetPhotosError_BadURLFound:
			return @"Bad URL found";
  
		default:
			return @"Unknown error code";
    }
}

@end
