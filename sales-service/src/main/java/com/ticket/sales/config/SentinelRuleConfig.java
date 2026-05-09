package com.ticket.sales.config;

import com.alibaba.csp.sentinel.slots.block.RuleConstant;
import com.alibaba.csp.sentinel.slots.block.degrade.DegradeRule;
import com.alibaba.csp.sentinel.slots.block.degrade.DegradeRuleManager;
import com.alibaba.csp.sentinel.slots.block.flow.FlowRule;
import com.alibaba.csp.sentinel.slots.block.flow.FlowRuleManager;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;
import java.util.List;

/**
 * Sentinel 规则配置类。
 * 
 * 功能：
 * 1. 冷启动限流：避免系统冷启动时流量突增导致服务雪崩
 * 2. 慢调用比例熔断：当接口 75% 的调用响应时间超过阈值时触发熔断
 */
@Slf4j
@Configuration
public class SentinelRuleConfig {

    /**
     * 初始化 Sentinel 规则。
     */
    @PostConstruct
    public void initRules() {
        initFlowRules();
        initDegradeRules();
        log.info("Sentinel 规则初始化完成");
    }

    /**
     * 初始化流控规则（冷启动限流）。
     * 
     * 冷启动限流（Warm-up 模式）：
     * - 系统冷启动时，限流阈值从较小值逐渐增加到配置值
     * - 避免冷启动时流量突增导致服务雪崩
     * - warmUpPeriodSec: 预热时长（秒）
     */
    private void initFlowRules() {
        List<FlowRule> rules = new ArrayList<>();

        // 购票接口：冷启动限流，预热 10 秒
        rules.add(createWarmUpRule("sellTicket", 100, 10));
        
        // 团体购票接口：冷启动限流，预热 10 秒
        rules.add(createWarmUpRule("groupSellTicket", 50, 10));
        
        // 退票接口：冷启动限流，预热 5 秒
        rules.add(createWarmUpRule("refundTicket", 80, 5));
        
        // 团体退票接口：冷启动限流，预热 5 秒
        rules.add(createWarmUpRule("groupRefundTicket", 40, 5));
        
        // 改签接口：冷启动限流，预热 5 秒
        rules.add(createWarmUpRule("changeTicket", 60, 5));
        
        // 查询座位接口：冷启动限流，预热 3 秒
        rules.add(createWarmUpRule("seatAvailable", 200, 3));
        
        // 热点车次排行榜：冷启动限流，预热 5 秒
        rules.add(createWarmUpRule("salesTopTrains", 150, 5));

        FlowRuleManager.loadRules(rules);
        log.info("流控规则加载完成，共 {} 条规则", rules.size());
    }

    /**
     * 初始化熔断规则（75% 慢调用比例熔断）。
     * 
     * 慢调用比例熔断：
     * - 当接口响应时间超过 maxAllowedRt 的调用比例达到 75% 时触发熔断
     * - 熔断时长：timeWindow（秒）
     * - 最小请求数：minRequestAmount
     * - 统计时长：statIntervalMs（毫秒）
     */
    private void initDegradeRules() {
        List<DegradeRule> rules = new ArrayList<>();

        // 购票接口：75% 慢调用熔断，慢调用阈值 500ms
        rules.add(createSlowCallRatioRule("sellTicket", 500, 0.75, 10, 5, 10000));
        
        // 团体购票接口：75% 慢调用熔断，慢调用阈值 1000ms
        rules.add(createSlowCallRatioRule("groupSellTicket", 1000, 0.75, 10, 10, 10000));
        
        // 退票接口：75% 慢调用熔断，慢调用阈值 300ms
        rules.add(createSlowCallRatioRule("refundTicket", 300, 0.75, 10, 5, 10000));
        
        // 团体退票接口：75% 慢调用熔断，慢调用阈值 500ms
        rules.add(createSlowCallRatioRule("groupRefundTicket", 500, 0.75, 10, 10, 10000));
        
        // 改签接口：75% 慢调用熔断，慢调用阈值 500ms
        rules.add(createSlowCallRatioRule("changeTicket", 500, 0.75, 10, 5, 10000));
        
        // 查询座位接口：75% 慢调用熔断，慢调用阈值 200ms
        rules.add(createSlowCallRatioRule("seatAvailable", 200, 0.75, 10, 3, 10000));
        
        // 热点车次排行榜：75% 慢调用熔断，慢调用阈值 300ms
        rules.add(createSlowCallRatioRule("salesTopTrains", 300, 0.75, 10, 5, 10000));

        DegradeRuleManager.loadRules(rules);
        log.info("熔断规则加载完成，共 {} 条规则", rules.size());
    }

    /**
     * 创建冷启动限流规则。
     * 
     * @param resource 资源名称
     * @param count QPS 阈值
     * @param warmUpPeriodSec 预热时长（秒）
     * @return 限流规则
     */
    private FlowRule createWarmUpRule(String resource, double count, int warmUpPeriodSec) {
        FlowRule rule = new FlowRule();
        rule.setResource(resource);
        rule.setGrade(RuleConstant.FLOW_GRADE_QPS);
        rule.setCount(count);
        rule.setStrategy(RuleConstant.STRATEGY_DIRECT);
        rule.setControlBehavior(RuleConstant.CONTROL_BEHAVIOR_WARM_UP);
        rule.setWarmUpPeriodSec(warmUpPeriodSec);
        return rule;
    }

    /**
     * 创建慢调用比例熔断规则。
     * 
     * @param resource 资源名称
     * @param maxAllowedRt 最大允许响应时间（毫秒）
     * @param ratio 慢调用比例阈值（0-1）
     * @param minRequestAmount 最小请求数
     * @param timeWindow 熔断时长（秒）
     * @param statIntervalMs 统计时长（毫秒）
     * @return 熔断规则
     */
    private DegradeRule createSlowCallRatioRule(
            String resource,
            int maxAllowedRt,
            double ratio,
            int minRequestAmount,
            int timeWindow,
            int statIntervalMs) {
        DegradeRule rule = new DegradeRule();
        rule.setResource(resource);
        rule.setGrade(RuleConstant.DEGRADE_GRADE_RT);
        rule.setCount(ratio);
        rule.setTimeWindow(timeWindow);
        rule.setMinRequestAmount(minRequestAmount);
        rule.setStatIntervalMs(statIntervalMs);
        rule.setSlowRatioThreshold(maxAllowedRt);
        return rule;
    }
}
