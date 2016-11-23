//
//  ImageAnalysis.cpp
//  SorghumYield
//
//  Created by cis on 23/11/2016.
//  Copyright © 2016 Robert Sebek. All rights reserved.
//
#import "ImageAnalysis.hpp"


#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/core/core_c.h>

#include <queue>
#include "vector"
#include <iostream>
#include <math.h>
#include <string.h>

using namespace::cv;
using namespace::std;

@implementation ImageAnalysis
@synthesize images;



const int minPercentContour = 5;


//inpaint
bool inpaintAllowed= false;

//canny
int thresh = 30;


//dilation
int dilation_size = 3;

//scaling
float imageScale=0.5;
vector<Vec4i> hierarchy;

static double angle( cv::Point pt1, cv::Point pt2, cv::Point pt0 )
{
    double dx1 = pt1.x - pt0.x;
    double dy1 = pt1.y - pt0.y;
    double dx2 = pt2.x - pt0.x;
    double dy2 = pt2.y - pt0.y;
    return (dx1*dx2 + dy1*dy2)/sqrt((dx1*dx1 + dy1*dy1)*(dx2*dx2 + dy2*dy2) + 1e-10);
}
//// returns sequence of squares detected on the image.
//// the sequence is stored in the specified memory storage
double mySquareFinder(vector< vector<cv::Point> >  & contours, vector<cv::Point> & square, int imageSize){
    
    vector<vector<cv::Point> >::iterator it;
    double lowerThreshHoldSize = 0.01;
    double upperThreshHoldSize = 0.09;
    
    double curBiggest = 0 ;
    vector<cv::Point> approx;
    for(it = contours.begin();  it != contours.end();it++ ){
        
        
        // approximate contour with accuracy proportional
        // to the contour perimeter
        approxPolyDP(Mat(*it), approx, arcLength(Mat(*it), true)*0.02, true);
        
        double squareSizePercent = fabs(contourArea(Mat(approx))/imageSize);
        
        if( approx.size() == 4 &&
           squareSizePercent > lowerThreshHoldSize  && squareSizePercent < upperThreshHoldSize &&
           isContourConvex(Mat(approx))
           )
        {
            double maxCosine = 0;
            for( int j = 2; j < 5; j++ )
            {
                // find the maximum cosine of the angle between joint edges
                double cosine = fabs(angle(approx[j%4], approx[j-2], approx[j-1]));
                maxCosine = MAX(maxCosine, cosine);
            }
            
            if( maxCosine < 0.25){
                if(squareSizePercent> curBiggest) {
                    curBiggest = squareSizePercent;
                    square = approx;
                }
                
                return squareSizePercent;
            }
            
        }
    }
    
    return 0;
}
//// the function draws all the squares in the image
static void drawSquares( Mat& image, const vector<cv::Point>& square )
{
    const cv::Point* p = &square[0];
    int n = (int)square.size();
    polylines(image, &p, &n, 1, true, Scalar(255,0,0), 15, 1);
    
}
//-----------------------------------------------------//Squares.cpp Algo--------------------------------------------------------



//-----------------------------------------------------Edge Analysis Algo--------------------------------------------------------

void shadowRemoval(Mat & src){
    Mat hsvImg;
    cvtColor(src, hsvImg, CV_BGR2HSV);
    Mat channel[3];
    split(hsvImg, channel);
    src = channel[1];
}


double discardLinesAndFindLargest( vector< vector<cv::Point> >  & contours, vector<cv::Point> & largestContour, int imageSize ){
    
    vector<vector<cv::Point> >::iterator it;
    
    double largestContourArea = 0 ;
    
    for(it = contours.begin();  it != contours.end();it++ ){
        float sizeLimit = imageSize/(100/minPercentContour);
        double area =contourArea(*it);
        if(area>=sizeLimit){
            if(area > largestContourArea){
                largestContourArea=area;
                largestContour = *it;
            }
        }
    }
    return largestContourArea;
}

void Erosion( Mat & canny_output)
{
    int dilation_type;
    dilation_type = MORPH_RECT;
    
    Mat dilationElement = getStructuringElement( dilation_type,
                                                cv::Size( 2*dilation_size + 1, 2*dilation_size+1 ),
                                                cv::Point( dilation_size, dilation_size ) );
    
    
    dilate( canny_output, canny_output, dilationElement );
}

Mat Prep(Mat & src ){
    if(src.rows>src.cols){
        cv::Size size(1440,1920);
        resize(src, src, size);
    }
    else{
        cv::Size size(1920,1440);
        resize(src, src, size);
    }
    Mat src_gray(src);
    
    Mat hsvImg;
    cvtColor(src, hsvImg, CV_BGR2HSV);
    Mat channel[3];
    split(hsvImg, channel);
    src_gray = channel[1];
    
    blur( src_gray, src_gray, cv::Size(5,5) );
    
    return src_gray;
}
void DrawContoursToImage(Mat & drawing, vector<vector<cv::Point> > & contours){
    /// Draw contours
    for( int i = 0; i< contours.size(); i++ )
    {
        
        drawContours( drawing, contours, i, Scalar(0,255,0), 15*(imageScale), 8, hierarchy, 0, cv::Point() );
    }
}

- (UIImage * ) analysis: (UIImage *) image : ( NSNumber ** ) result : ( AnalysisResults *) state {
    
    
    
    Mat src = [self cvMatFromUIImage:image];
    
    vector<cv::Point>  square;
    vector<vector<cv::Point> > contours;
    
    Mat src_gray =Prep(src);
    
    int imageSize = src.rows * src.cols;
    
    //double squareSize = findSquares(src, square, imageSize);
    
    Mat canny_output;
    
    Canny( src_gray, canny_output, thresh, thresh*2, 3 );
    
    Erosion(canny_output);
    
    
    /// Find contours
    findContours( canny_output, contours, hierarchy, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE );
    
    double squareSize = mySquareFinder(contours, square,imageSize);
    
    if(squareSize==0)
        return NULL;
    
    vector <cv::Point> largestContour;
    double biggestContourArea = discardLinesAndFindLargest(contours, largestContour, imageSize);
    
    
    contours.clear();
    contours.push_back(largestContour);
    DrawContoursToImage(src, contours);
    
    drawSquares(src, square);
    
    
    *result = [NSNumber numberWithDouble:((biggestContourArea/(src.rows* src.cols)) / squareSize) ];
    
    return [self UIImageFromCVMat:src];
}

//-----------------------------------------------------//Edge Analysis Algo--------------------------------------------------------
- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}
-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return finalImage;
}




@end
