#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    b2Fixture *armFixture;
    b2Body *armBody;
	b2World* world;
	GLESDebugDraw *m_debugDraw;
}

+(CCScene *) scene;


@end
