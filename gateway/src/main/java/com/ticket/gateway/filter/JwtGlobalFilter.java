package com.ticket.gateway.filter;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.List;

/**
 * Gateway 全局 JWT 过滤器。
 */
@Component
public class JwtGlobalFilter implements GlobalFilter, Ordered {

    private static final String HMAC_SHA256 = "HmacSHA256";

    @Value("${jwt.secret:rts-dev-secret}")
    private String jwtSecret;

    private final AntPathMatcher pathMatcher = new AntPathMatcher();

    private final List<String> whiteList = List.of(
            "/api/user/login",
            "/api/user/register",
            "/api/train/**",
            "/api/station/**",
            "/api/route/**",
            "/api/dictionary/**",
            "/doc.html",
            "/swagger-ui/**",
            "/v3/api-docs/**",
            "/webjars/**",
            "/ws/**",
            "/actuator/**"
    );

    /**
     * 处理网关请求鉴权。
     */
    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest().mutate().headers(headers -> {
            headers.remove("X-User-Id");
            headers.remove("X-User-Role");
            headers.remove("X-Auth-Timestamp");
            headers.remove("X-Auth-Signature");
        }).build();
        exchange = exchange.mutate().request(request).build();
        String path = request.getURI().getPath();

        boolean isWhiteListed = false;
        for (String pattern : whiteList) {
            if (pathMatcher.match(pattern, path)) {
                isWhiteListed = true;
                break;
            }
        }

        // 解析 Authorization（无论是否白名单，有 token 就解析）
        String authHeader = request.getHeaders().getFirst("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            try {
                SecretKey key = Keys.hmacShaKeyFor(padKey(jwtSecret.getBytes(StandardCharsets.UTF_8)));
                Claims claims = Jwts.parser()
                        .verifyWith(key)
                        .build()
                        .parseSignedClaims(token)
                        .getPayload();

                String userId = claims.get("userId", String.class);
                String role = claims.get("role", String.class);
                if (userId != null && !userId.isBlank()) {
                    String timestamp = String.valueOf(System.currentTimeMillis());
                    String signature = buildInternalRequestSignature(userId, role, timestamp);
                    ServerHttpRequest mutatedRequest = request.mutate()
                            .header("X-User-Id", userId)
                            .header("X-User-Role", role == null ? "" : role)
                            .header("X-Auth-Timestamp", timestamp)
                            .header("X-Auth-Signature", signature)
                            .build();
                    return chain.filter(exchange.mutate().request(mutatedRequest).build());
                }
            } catch (Exception ignored) {
                // token 无效：白名单路径继续放行，非白名单拒绝
            }
        }

        // 白名单路径：即使没有 token 也放行（匿名访问）
        if (isWhiteListed) {
            return chain.filter(exchange);
        }

        // 非白名单路径：必须有有效 token
        exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
        return exchange.getResponse().setComplete();
    }

    /**
     * 补齐 JWT 密钥长度。
     */
    private byte[] padKey(byte[] keyBytes) {
        if (keyBytes.length >= 32) {
            return keyBytes;
        }
        byte[] padded = new byte[32];
        System.arraycopy(keyBytes, 0, padded, 0, keyBytes.length);
        return padded;
    }

    private String buildInternalRequestSignature(String userId, String role, String timestamp) {
        try {
            Mac mac = Mac.getInstance(HMAC_SHA256);
            mac.init(new SecretKeySpec(padKey(jwtSecret.getBytes(StandardCharsets.UTF_8)), HMAC_SHA256));
            byte[] digest = mac.doFinal((userId + "|" + (role == null ? "" : role) + "|" + timestamp).getBytes(StandardCharsets.UTF_8));
            return Base64.getUrlEncoder().withoutPadding().encodeToString(digest);
        } catch (Exception e) {
            throw new IllegalStateException("Failed to sign internal headers", e);
        }
    }

    /**
     * 返回过滤器顺序。
     */
    @Override
    public int getOrder() {
        return -100;
    }
}
