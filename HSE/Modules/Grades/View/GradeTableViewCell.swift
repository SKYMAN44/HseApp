//
//  GradeTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 14.02.2022.
//

import UIKit

final class GradeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "GradeTableViewCell"
    static let shimmerReuseIdentifier = "ShimmerGradeTableViewCelll"
    
    private var isShimmerMode: Bool = false
    
    private let taskNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textAndIcons.style(.primary)()
        label.font = .customFont.style(.body)()
        label.numberOfLines = 0
        label.textAlignment = .left
        
        return label
    }()
    
    private let taskNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textAndIcons.style(.primary)()
        label.font = .customFont.style(.body)()
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    private let taskGradeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textAndIcons.style(.primary)()
        label.font = .customFont.style(.body)()
        label.numberOfLines = 1
        label.textAlignment = .right
        
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textAndIcons.style(.tretiary)()
        label.font = .customFont.style(.footnote)()
        label.text = "No."
        label.textAlignment = .left
        
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textAndIcons.style(.tretiary)()
        label.font = .customFont.style(.footnote)()
        label.text = "Name"
        label.textAlignment = .left
        
        return label
    }()
    
    private let gradeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textAndIcons.style(.tretiary)()
        label.font = .customFont.style(.footnote)()
        label.textAlignment = .right
        label.text = "Grade"
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(isShimmerMode) {
            stopShimmer()
            startShimmer()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isShimmerMode = false
        stopShimmer()
    }
    
    deinit { }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupView() {
        let gradeSV = UIStackView(arrangedSubviews: [taskGradeLabel, gradeLabel])
        gradeSV.distribution = .fill
        gradeSV.alignment = .fill
        gradeSV.axis = .vertical
        gradeSV.spacing = 2
        
        let nameSV = UIStackView(arrangedSubviews: [taskNameLabel, nameLabel])
        nameSV.distribution = .fill
        nameSV.alignment = .fill
        nameSV.axis = .vertical
        nameSV.spacing = 2
        
        let numberSV = UIStackView(arrangedSubviews: [taskNumberLabel, numberLabel])
        numberSV.distribution = .fill
        numberSV.alignment = .fill
        numberSV.axis = .vertical
        numberSV.spacing = 2
        
        let mainSV = UIStackView(arrangedSubviews: [numberSV, nameSV, gradeSV])
        mainSV.distribution = .fill
        mainSV.alignment = .fill
        mainSV.axis = .horizontal
        mainSV.spacing = 20
        
        contentView.addSubview(mainSV)
        
        mainSV.pin(to: contentView, [.top: 8, .bottom: 8, .left: 16, .right: 16])
    }
    
    public func configure(grade: Grade) {
        taskNumberLabel.text = String(grade.number)
        taskNameLabel.text = grade.name
        taskGradeLabel.text = String(grade.grade)
    }
    
    public func configureShimmer() {
        taskNameLabel.text = "                       "
        taskNumberLabel.text = "     "
        taskGradeLabel.text = "     "
        numberLabel.text = "     "
        nameLabel.text = "     "
        gradeLabel.text = "    "
        isShimmerMode = true
    }

}

extension GradeTableViewCell: ShimmeringObject {
    func startShimmer() {
        applyShimmerTo(to: [taskNameLabel,
                           taskNumberLabel,
                           taskGradeLabel,
                           gradeLabel,
                           numberLabel,
                           nameLabel])
    }
    
    func stopShimmer() {
        removeShimmerFrom(from: [taskNameLabel,
                                 taskNumberLabel,
                                 taskGradeLabel,
                                 gradeLabel,
                                 numberLabel,
                                 nameLabel])
    }
}
