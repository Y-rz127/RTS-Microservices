package com.ticket.model.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ThreadPoolStatus {
    private int corePoolSize;
    private int maximumPoolSize;
    private int activeCount;
    private int queueSize;
    private long completedTaskCount;
    private int poolSize;
    private int largestPoolSize;
    private int remainingQueueCapacity;
}
