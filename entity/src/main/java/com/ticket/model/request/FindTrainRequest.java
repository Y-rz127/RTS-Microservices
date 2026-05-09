package com.ticket.model.request;

import lombok.Data;
import java.math.BigDecimal;
import java.sql.Time;

/**
 * 车次查询请求模型
 */
@Data
public class FindTrainRequest {

    private Integer trainId;
    private String trainNumber;
    private String trainType;
    private String startStation;
    private String endStation;
    // 时间范围查询字段（适配高级查询）
    private Time minDepartureTime; // 最小出发时间
    private Time maxDepartureTime; // 最大出发时间
    private Time minArrivalTime;   // 最小到达时间
    private Time maxArrivalTime;   // 最大到达时间
    private BigDecimal basePrice;
    private Integer status;        // 车次状态（1=正常，0=停运）
    private Boolean showAll;       // 是否显示所有车次（管理端用，默认false只显示正常运行的）
}
