//
//  CurveView.swift
//  YetAnotherWeatherApp
//
//  Created by Filippo Tosetto on 16/07/2015.
//

import UIKit

class CurveView: UIView {
    var dataPoints: [CGPoint]?
    
    var weather: [Weather]? {
        didSet {
            
            let data = weather!.map { Double($0.temperature) }
            
            let max = Double(data.dropFirst().reduce(data[0]) { $0 < $1 ? $1 : $0 }) + 5.0
            let min = Double(data.dropFirst().reduce(data[0]) { $0 > $1 ? $1 : $0 }) - 5.0
            let height = Double(self.frame.height - 50)
            
            self.dataPoints = [CGPoint]()
            let step = Double(self.frame.width) / Double(data.count - 1)
            for (index, temp) in data.enumerate() {
                self.dataPoints?.append(CGPoint(x: (step * Double(index)), y: (temp - min) / (max - min)  * height))
            }
            
            self.setNeedsDisplay()
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        if let points = dataPoints, let bezier = interpolateWithHermite(points) {
            bezier.lineWidth = 2.0
            bezier.stroke()
        }
    }
    
}

extension CurveView {

    func interpolateWithHermite(points: [CGPoint]) -> UIBezierPath? {
        if points.count < 2 {
            return nil
        }
        
        let nCurves = points.count-1
        
        let path = UIBezierPath()
        
        for var ii = 0; ii < nCurves; ++ii {
            
            var curPt, prevPt, nextPt, endPt : CGPoint
            curPt = points[ii]
            
            if ii == 0 {
                path.moveToPoint(curPt)
            }
            
            var nextii = (ii+1) % points.count
            var previi = ii-1 < 0 ? points.count-1 : ii-1;
            
            prevPt = points[previi]
            nextPt = points[nextii]
            
            endPt = nextPt
            
            
            var mx, my: CGFloat
            
            if (ii > 0) {
                mx = (nextPt.x - curPt.x)*0.5 + (curPt.x - prevPt.x)*0.5
                my = (nextPt.y - curPt.y)*0.5 + (curPt.y - prevPt.y)*0.5
            } else {
                mx = (nextPt.x - curPt.x)*0.5
                my = (nextPt.y - curPt.y)*0.5
            }
            
            
            let ctrlPt1 = CGPointMake(curPt.x + mx / 3.0, curPt.y + my / 3.0)
            
            curPt = points[nextii]
            
            nextii = (nextii+1) % points.count
            previi = ii
            
            prevPt = points[previi]
            nextPt = points[nextii]
            
            if (ii < nCurves-1) {
                mx = (nextPt.x - curPt.x)*0.5 + (curPt.x - prevPt.x)*0.5
                my = (nextPt.y - curPt.y)*0.5 + (curPt.y - prevPt.y)*0.5
            }
            else {
                mx = (curPt.x - prevPt.x)*0.5
                my = (curPt.y - prevPt.y)*0.5
            }

            let ctrlPt2 = CGPointMake(curPt.x - mx / 3.0, curPt.y - my / 3.0)
            
            path.addCurveToPoint(endPt, controlPoint1: ctrlPt1, controlPoint2: ctrlPt2)
        }
        
        return path
    }
}

extension CurveView {
    
    func ccpDot(v1: CGPoint, v2:  CGPoint) -> CGFloat {
        return v1.x*v2.x + v1.y*v2.y
    }
    
    func ccpLengthSQ(v: CGPoint) -> CGFloat {
        return ccpDot(v, v2: v)
    }
    
    func ccpLength(v: CGPoint) -> CGFloat {
        return CGFloat(sqrtf(Float(ccpLengthSQ(v))))
    }
    
    func ccpSub(v1: CGPoint, v2: CGPoint) -> CGPoint {
        return CGPoint(x: v1.x - v2.x, y: v1.y - v2.y)
    }
    
    func ccpMult(v: CGPoint, s: CGFloat) -> CGPoint {
        return CGPoint(x: v.x*s, y: v.y*s)
    }
    
    func ccpAdd(v1: CGPoint, v2: CGPoint) -> CGPoint {
        return CGPoint(x: v1.x + v2.x, y: v1.y + v2.y)
    }
}


