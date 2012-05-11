#import "HelloWorldLayer.h"
#define PTM_RATIO 32
#define FLOOR_HEIGHT  62.0f
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};



@implementation HelloWorldLayer

+(CCScene *) scene
{

	CCScene *scene = [CCScene node];
	

	HelloWorldLayer *layer = [HelloWorldLayer node];
	

	[scene addChild: layer];
	

	return scene;
}


-(id) init
{
	if( (self=[super init])) {
		
        self.isTouchEnabled = YES;
		

		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
		
		b2Vec2 gravity;
		gravity.Set(0.0f, -10.0f);
		
		bool doSleep = true;
		
		
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
//		flags += b2DebugDraw::e_jointBit;
//		flags += b2DebugDraw::e_aabbBit;
//		flags += b2DebugDraw::e_pairBit;
//		flags += b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);		
		
		CCSprite *sprite = [CCSprite spriteWithFile:@"bg.png"];
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite z:-1];
        
        sprite = [CCSprite spriteWithFile:@"catapult_base_2.png"];
        sprite.anchorPoint = CGPointMake(181.0f, FLOOR_HEIGHT);
        [self addChild:sprite z:0];
        
        sprite = [CCSprite spriteWithFile:@"squirrel_1.png"];
        sprite.anchorPoint = CGPointMake(11.0f, FLOOR_HEIGHT);
        [self addChild:sprite z:0];
        
        sprite = [CCSprite spriteWithFile:@"catapult_base_1.png"];
        sprite.anchorPoint = CGPointMake(181.0f, FLOOR_HEIGHT);
        [self addChild:sprite z:9];
        
        sprite = [CCSprite spriteWithFile:@"squirrel_2.png"];
        sprite.anchorPoint = CGPointMake(240.0f, FLOOR_HEIGHT);
        [self addChild:sprite z:9];
        
        sprite = [CCSprite spriteWithFile:@"fg.png"];
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite z:10];
        
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0, 0); // bottom-left corner
		
		b2Body* groundBody = world->CreateBody(&groundBodyDef);
		

		b2PolygonShape groundBox;		
		

		groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(screenSize.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);
		
		
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
		
		
		groundBox.SetAsEdge(b2Vec2(0,screenSize.height/PTM_RATIO), b2Vec2(0,0));
		groundBody->CreateFixture(&groundBox,0);
		
		
		groundBox.SetAsEdge(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,0));
		groundBody->CreateFixture(&groundBox,0);
		
		
		
		
				
		[self schedule: @selector(tick:)];
	}
	return self;
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}


-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);

	

	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {

			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
}




- (void) dealloc
{

	delete world;
	world = NULL;
	
	delete m_debugDraw;


	[super dealloc];
}
@end
