package com.ticket.gateway.filter;

import com.alibaba.csp.sentinel.slots.block.RuleConstant;
import com.alibaba.csp.sentinel.slots.block.flow.FlowRule;
import com.alibaba.csp.sentinel.slots.block.flow.FlowRuleManager;
import jakarta.annotation.PostConstruct;
import org.springframework.context.annotation.Configuration;

import java.util.List;

/**
 * Gateway Sentinel 规则配置类。
 */
@Configuration
public class GatewaySentinelRuleConfig {

    /**
     * 初始化默认限流规则。
     */
    @PostConstruct
    public void initRules() {
        FlowRule userAuthRule = createRule("gateway:user-auth", 200);
        FlowRule trainRule = createRule("gateway:train", 300);
        FlowRule salesRule = createRule("gateway:sales", 200);
        FlowRule approvalRule = createRule("gateway:approval", 100);
        FlowRule notificationRule = createRule("gateway:notification", 100);
        FlowRule otherRule = createRule("gateway:other", 100);
        FlowRuleManager.loadRules(List.of(userAuthRule, trainRule, salesRule, approvalRule, notificationRule, otherRule));
    }

    /**
     * 创建单个限流规则。
     */
    private FlowRule createRule(String resource, double count) {
        FlowRule rule = new FlowRule();
        rule.setResource(resource);
        rule.setGrade(RuleConstant.FLOW_GRADE_QPS);
        rule.setCount(count);
        return rule;
    }
}
