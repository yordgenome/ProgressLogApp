//
//  BarChartView.swift
//  WorkoutVolumeDiary
//
//  Created by Yo Tahara on 2022/05/26.
//
import UIKit


class BarChartView: UIView {
    
    private var partInfos: [PartInfo] = []
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
    }
    
    func configure(partInfos: [PartInfo]) {
        self.partInfos = partInfos
        
        // カスタムビューの再描画(drawメソッドの呼び出し)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        // pertInfosのvalueの値の合計値
        let valueTotal = partInfos.map(\.value).reduce(0, +)
        
        // percentとカラーをタプル化
        let percentAndColorList = partInfos.map {
            return ( percent: $0.value / valueTotal,
                     color: $0.color)
        }
        
        var startPercent: Float = 0
        
        // タプル配列から円グラフを描画
        percentAndColorList.forEach {
            drawPart(startPercent: startPercent,
                     endPercent: $0.percent,
                     fillColor: $0.color)
            // 描画開始位置を更新
            startPercent += $0.percent
        }
        
    }
    
    // 描画メソッド
    func drawPart(startPercent: Float,
                  endPercent: Float,
                  fillColor: UIColor) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.systemBackground.cgColor)
        context?.setFillColor(fillColor.cgColor)
        
        let path = UIBezierPath()
        path.lineWidth = 1
        
        let barLength = self.bounds.width - 40
        let startPoint = CGPoint(x: 20 + barLength * CGFloat(startPercent), y: self.bounds.width/8)
        
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: startPoint.x + barLength * CGFloat(endPercent), y: startPoint.y))
        path.addLine(to: CGPoint(x: startPoint.x + barLength * CGFloat(endPercent), y: startPoint.y + 60))
        path.addLine(to: CGPoint(x: startPoint.x, y: startPoint.y + 60))
        // 中心から弧の描画開始点まで描画（pathが一周する）
        path.close()
        path.fill()
        path.stroke()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
