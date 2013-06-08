//
//  QDSystem.m
//  QDWaterLrrigation
//
//  Created by Mako on 13-1-30.
//
//

#import "QDSystem.h"

@implementation QDSystem
@synthesize soundFileURLRef;
@synthesize soundFileObject;

-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
        NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"tap"
                                                    withExtension: @"aif"];
        self.soundFileURLRef = (CFURLRef) [tapSound retain];
        
        [tapSound release];
        AudioServicesCreateSystemSoundID (
                                          
                                          soundFileURLRef,
                                          &soundFileObject
                                          );
        
        
    }
    return self;

}
-(void)playSound
{
    AudioServicesPlaySystemSound (soundFileObject);
}
-(void)stopSound
{
    AudioServicesPlayAlertSound (soundFileObject);
}
-(void)OpenShock
{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}
-(void)stopShock
{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

-(void)dealloc
{
    [super dealloc];
}

@end
