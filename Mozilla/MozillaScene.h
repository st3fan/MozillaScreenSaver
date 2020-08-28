// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import <SpriteKit/SpriteKit.h>
#import <Cocoa/Cocoa.h>

@interface MozillaScene : SKScene <SKPhysicsContactDelegate> {
    BOOL _isPreview;
}
@property NSInteger logoIndex;
@property SKSpriteNode *logo;
- (instancetype) initWithSize:(CGSize)size isPreview: (BOOL) isPreview;
@end
