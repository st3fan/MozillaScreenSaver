// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

#import <SpriteKit/SpriteKit.h>
#import <ScreenSaver/ScreenSaver.h>

@class MozillaScene;

@interface MozillaView : ScreenSaverView {
    SKView *_sceneView;
    MozillaScene *_scene;
}

@property SKView *sceneView;
@property MozillaScene *scene;

@end
