package com.ticket.sales.task;

import com.ticket.sales.mapper.SeatMapper;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Date;

@Slf4j
@Component
public class SeatCleanupTask {

    private final SeatMapper seatMapper;

    public SeatCleanupTask(SeatMapper seatMapper) {
        this.seatMapper = seatMapper;
    }

    /**
     * 服务启动清理
     */
    @PostConstruct
    public void cleanOnStartup() {
        try {
            manualCleanup();
        } catch (Exception e) {
            log.error("启动时清理失败", e);
        }
    }

    /**
     * 每日凌晨两点自动清理
     */
    @Scheduled(cron = "0 0 2 * * ?")
    public void cleanExpiredSeats() {
        log.info("定时任务启动：清理过期座位数据");
        manualCleanup();
    }
    
    public void manualCleanup() {
        Date today = new Date();
        today.setHours(0); today.setMinutes(0); today.setSeconds(0);
        seatMapper.deleteExpiredSeatsNotReferenced(today);
    }
}
