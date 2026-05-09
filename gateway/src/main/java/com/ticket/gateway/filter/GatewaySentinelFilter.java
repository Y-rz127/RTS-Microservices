package com.ticket.gateway.filter;

import com.alibaba.csp.sentinel.Entry;
import com.alibaba.csp.sentinel.EntryType;
import com.alibaba.csp.sentinel.SphU;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

/**
 * Gateway 的 Sentinel 全局过滤器。
 */
@Component
public class GatewaySentinelFilter implements GlobalFilter, Ordered {

    /**
     * 对网关请求执行限流检查。
     */
    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        String resource = mapResource(request.getURI().getPath());
        try {
            Entry entry = SphU.entry(resource, EntryType.IN);
            return chain.filter(exchange).doFinally(signalType -> {
                entry.exit();
            });
        } catch (BlockException ex) {
            exchange.getResponse().setStatusCode(HttpStatus.TOO_MANY_REQUESTS);
            return exchange.getResponse().setComplete();
        }
    }

    /**
     * 将请求路径映射为 Sentinel 资源名。
     */
    private String mapResource(String path) {
        if (path.startsWith("/api/user/") || path.startsWith("/api/config/") || path.startsWith("/api/log/")) {
            return "gateway:user-auth";
        }
        if (path.startsWith("/api/train/") || path.startsWith("/api/station/") || path.startsWith("/api/route/")
                || path.startsWith("/api/dictionary/") || path.startsWith("/api/statistics/")) {
            return "gateway:train";
        }
        if (path.startsWith("/api/orders/") || path.startsWith("/api/pay/") || path.startsWith("/api/tickets/")
                || path.startsWith("/api/seats/") || path.startsWith("/api/async/") || path.startsWith("/api/hot/")
                || path.startsWith("/api/sales/")) {
            return "gateway:sales";
        }
        if (path.startsWith("/api/approval/") || path.startsWith("/api/operator/approval/")) {
            return "gateway:approval";
        }
        if (path.startsWith("/ws/")) {
            return "gateway:notification";
        }
        return "gateway:other";
    }

    /**
     * 返回过滤器顺序。
     */
    @Override
    public int getOrder() {
        return -200;
    }
}
