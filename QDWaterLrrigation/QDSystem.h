//
//  QDSystem.h
//  QDWaterLrrigation
//
//  Created by Mako on 13-1-30.
//
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface QDSystem : NSObject
{
	CFURLRef		soundFileURLRef;
	SystemSoundID	soundFileObject;
}
@property (readwrite)	CFURLRef		soundFileURLRef;
@property (readonly)	SystemSoundID	soundFileObject;
-(void)playSound;
-(void)stopSound;
-(void)OpenShock;
-(void)stopShock;


@end
