//
//  CCDCGraphViewController.m
//  PowerUsageApp
//
//  Created by Jacob Persson on 10/24/09.
//  Copyright 2009 RobotCrowd. All rights reserved.
//

#import "CCDCGraphDateViewController.h"


@implementation CCDCGraphDateViewController

@synthesize dataForPlot;

- (void)viewDidLoad {
  [super viewDidLoad];
  
	//NSDate *refDate = [NSDate dateWithNaturalLanguageString:@"0:00 Jan 1, 2007"];
  NSDate *refDate = [NSDate dateWithTimeIntervalSince1970:0];
  NSTimeInterval oneDay = 24 * 60 * 60;
  
  // Create graph from theme
  graph = [[CPXYGraph alloc] initWithFrame:CGRectZero];
  CPTheme *theme = [CPTheme themeNamed:kCPDarkGradientTheme];
  [graph applyTheme:theme];
  CPLayerHostingView *hostingView = (CPLayerHostingView *)self.view;
  hostingView.hostedLayer = graph;
    
  graph.paddingLeft = 5.0;
  graph.paddingTop = 5.0;
  graph.paddingRight = 5.0;
  graph.paddingBottom = 5.0;
  
  // Setup plot space
  CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
  plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.0) length:CPDecimalFromFloat(oneDay * 365)];
  plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.0) length:CPDecimalFromFloat(1050.0)];
  
  // Axes
	CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
  CPXYAxis *x = axisSet.xAxis;
  x.majorIntervalLength = CPDecimalFromFloat(oneDay * 7);
  x.constantCoordinateValue = CPDecimalFromString(@"0");
  x.minorTicksPerInterval = 0;
  NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
  dateFormatter.dateStyle = kCFDateFormatterShortStyle;
  CPTimeFormatter *timeFormatter = [[[CPTimeFormatter alloc] initWithDateFormatter:dateFormatter] autorelease];
  timeFormatter.referenceDate = refDate;
  x.axisLabelFormatter = timeFormatter;
  
  CPXYAxis *y = axisSet.yAxis;
  y.majorIntervalLength = CPDecimalFromString(@"100");
  y.minorTicksPerInterval = 0;
  y.constantCoordinateValue = CPDecimalFromFloat(oneDay * 7 * 10); //CPDecimalFromString(@"100");
  y.axisLabelOffset = -60;
  y.title = @"kWh";
  y.axisTitleOffset = 45.0f;
  
  NSArray *exclusionRanges = [NSArray arrayWithObjects:
                              [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.00) length:CPDecimalFromFloat(10.0)], 
                              nil];
//                     [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(1.99) length:CPDecimalFromFloat(0.02)], 
//                     [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.99) length:CPDecimalFromFloat(0.02)],
//                     [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(3.99) length:CPDecimalFromFloat(0.02)],
//                     nil];
  y.labelExclusionRanges = exclusionRanges;
  
  // Create a blue plot area
  CPScatterPlot *boundLinePlot = [[[CPScatterPlot alloc] init] autorelease];
  boundLinePlot.identifier = @"Blue Plot";
  boundLinePlot.dataLineStyle.miterLimit = 1.0f;
  boundLinePlot.dataLineStyle.lineWidth = 3.0f;
  boundLinePlot.dataLineStyle.lineColor = [CPColor blueColor];
  boundLinePlot.dataSource = self;
  [graph addPlot:boundLinePlot];
  
  // Do a blue gradient
  CPColor *areaColor1 = [CPColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
  CPGradient *areaGradient1 = [CPGradient gradientWithBeginningColor:areaColor1 endingColor:[CPColor clearColor]];
  areaGradient1.angle = -90.0f;
  CPFill *areaGradientFill = [CPFill fillWithGradient:areaGradient1];
  boundLinePlot.areaFill = areaGradientFill;
  boundLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
  
  /*
  // Make a green zone
  greenZoneData = [[NSMutableArray alloc] initWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"x", [NSNumber numberWithInt:300], @"y", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:INT_MAX], @"x", [NSNumber numberWithInt:300], @"y", nil], nil];
  
  CPScatterPlot *greenZonePlot = [[[CPScatterPlot alloc] init] autorelease];
  greenZonePlot.identifier = @"Green Zone";
  greenZonePlot.dataLineStyle.lineWidth = 0.0f;
  greenZonePlot.dataSource = greenZoneData;
  
  CPColor *greenZoneColor = [CPColor colorWithComponentRed:0.2 green:0.7 blue:0.2 alpha:0.8];
  CPFill *greenZoneFill = [CPFill fillWithColor:greenZoneFill];
  boundLinePlot.areaFill = greenZoneFill;
  boundLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
   */
  
  // Add plot symbols
  CPLineStyle *symbolLineStyle = [CPLineStyle lineStyle];
  symbolLineStyle.lineColor = [CPColor blackColor];
  
  /*
  CPPlotSymbol *plotSymbol = [CPPlotSymbol ellipsePlotSymbol];
  plotSymbol.fill = [CPFill fillWithColor:[CPColor blueColor]];
  plotSymbol.lineStyle = symbolLineStyle;
  plotSymbol.size = CGSizeMake(10.0, 10.0);
  boundLinePlot.plotSymbol = plotSymbol;
   */
  
  // Create a green plot area
  /*CPScatterPlot *dataSourceLinePlot = [[[CPScatterPlot alloc] init] autorelease];
  dataSourceLinePlot.identifier = @"Green Plot";
  dataSourceLinePlot.dataLineStyle.lineWidth = 3.f;
  dataSourceLinePlot.dataLineStyle.lineColor = [CPColor greenColor];
  dataSourceLinePlot.dataSource = self;
  [graph addPlot:dataSourceLinePlot];
  
  // Put an area gradient under the plot above
  CPColor *areaColor = [CPColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
  CPGradient *areaGradient = [CPGradient gradientWithBeginningColor:areaColor endingColor:[CPColor clearColor]];
  areaGradient.angle = -90.0f;
  areaGradientFill = [CPFill fillWithGradient:areaGradient];
  dataSourceLinePlot.areaFill = areaGradientFill;
  dataSourceLinePlot.areaBaseValue = CPDecimalFromString(@"1");
  */
	
	
  // Add some initial data
  /*NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:100];
  NSUInteger i;
  for ( i = 0; i < 60; i++ ) {
    id x = [NSNumber numberWithFloat:1+i]; // days, right?
    id y = [NSNumber numberWithFloat:1.2*i*rand()/RAND_MAX]; // PWR consumption
    [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
  }*/
  self.dataForPlot = [self loadAndPreprocessData];
  [self adjustPlotRangeToData];
}

-(void)changePlotRange 
{
  // Setup plot space
  CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
  plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.0) length:CPDecimalFromFloat(3.0 + 2.0)];
  plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.0) length:CPDecimalFromFloat(3.0 + 2.0*rand()/RAND_MAX)];
}

-(void)adjustPlotRangeToData
{
  NSDictionary *firstDatapoint = [self.dataForPlot objectAtIndex:0];
  NSDictionary *lastDatapoint = [self.dataForPlot lastObject];
  
  NSDecimal start = CPDecimalFromInt([[firstDatapoint objectForKey:@"x"] intValue]);
  NSDecimal length = CPDecimalSubtract(CPDecimalFromInt([[lastDatapoint objectForKey:@"x"] intValue]), start);
      
  CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
  plotSpace.xRange = [CPPlotRange plotRangeWithLocation:start length:length];
  
  CPXYAxisSet *axisSet = (CPXYAxisSet *)graph.axisSet;
  CPXYAxis *yAxis = axisSet.yAxis; 
  yAxis.constantCoordinateValue = start;
}

- (NSMutableArray *)loadAndPreprocessData
{
	// Load the previous recordings from disk
  NSTimeInterval oneWeek = 7 * 24 * 60 * 60;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) {
		NSAssert(NO, @"Documents directory not found!");
	}
	
	NSString *recordingsFile = [documentsDirectory stringByAppendingPathComponent:@"recordings.plist"];
	
	NSArray *meterRecordings = [[NSMutableArray alloc] initWithContentsOfFile:recordingsFile];
	
	if (meterRecordings == nil)
		meterRecordings = [[NSMutableArray alloc] init];
	
	NSNumber *lastMeterValue = [NSNumber numberWithInt:0];
  NSNumber *lastTimestampValue = [NSNumber numberWithInt:0];
	NSMutableArray *processedData = [NSMutableArray array];
	for (NSDictionary *recording in meterRecordings) {
		NSNumber *meterValue = [recording objectForKey:@"meterValue"];
		NSNumber *deltaValue = [NSNumber numberWithInt:[meterValue intValue] -  [lastMeterValue intValue]];
		//NSNumber *timestamp = [NSNumber numberWithInt:[meterRecordings indexOfObject:recording]];
    
    NSDate *timestamp = [recording objectForKey:@"timestamp"];
    NSNumber *timestampValue = [NSNumber numberWithInt:[timestamp timeIntervalSince1970]];
    NSNumber *timestampDeltaValue = [NSNumber numberWithInt:[timestampValue intValue] - [lastTimestampValue intValue]];
    double weight = (double)oneWeek / [timestampDeltaValue doubleValue];
    NSNumber *weightedDeltaValue = [NSNumber numberWithDouble:[deltaValue doubleValue] * weight];
    
		lastMeterValue = meterValue;
    lastTimestampValue = timestampValue;
		NSLog(@"  timestamp: %@   value :%@", [timestamp description], [deltaValue description]);
		[processedData addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:timestampValue, @"x", weightedDeltaValue, @"y", nil]];
	}
	
	return processedData;
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot {
  return [dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
  NSNumber *num = [[dataForPlot objectAtIndex:index] valueForKey:(fieldEnum == CPScatterPlotFieldX ? @"x" : @"y")];
	// Green plot gets shifted above the blue
	if ([(NSString *)plot.identifier isEqualToString:@"Green Plot"])
	{
		if ( fieldEnum == CPScatterPlotFieldY ) 
			num = [NSNumber numberWithDouble:[num doubleValue] + 1.0];
	}
  return num;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
  [dataForPlot release];
  [super dealloc];
}


@end
