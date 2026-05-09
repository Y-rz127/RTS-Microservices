package com.ticket.utils;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 * 请求用户上下文工具类，用于从 HTTP 请求中获取当前用户信息。
 */
@Component
public class RequestUserContext {

    private final JwtUtils jwtUtils;

    public RequestUserContext(JwtUtils jwtUtils) {
        this.jwtUtils = jwtUtils;
    }

    /**
     * 获取当前用户 ID。
     */
    public Integer getCurrentUserId() {
        HttpServletRequest request = getCurrentRequest();
        if (request == null) {
            return null;
        }
        String userIdHeader = request.getHeader("X-User-Id");
        String roleHeader = request.getHeader("X-User-Role");
        String timestamp = request.getHeader("X-Auth-Timestamp");
        String signature = request.getHeader("X-Auth-Signature");
        if (jwtUtils.isValidInternalRequest(userIdHeader, roleHeader, timestamp, signature)) {
            try {
                return Integer.valueOf(userIdHeader);
            } catch (NumberFormatException ignored) {
            }
        }
        String authorization = getAuthorizationHeader(request,"Authorization");  //授权
        if (authorization != null && authorization.startsWith("Bearer ")) {
            try {
                String userId = jwtUtils.extractUserId(authorization.substring(7));
                if (userId != null && !userId.isBlank()) {
                    return Integer.valueOf(userId);
                }
            } catch (Exception ignored) {
            }
        }
        return null;
    }

    /**
     * 获取授权头。
     */
    public String getAuthorizationHeader(HttpServletRequest request, String s) {
        return request == null ? null : request.getHeader(s);
    }

    /**
     * 获取当前请求。
     */
    private HttpServletRequest getCurrentRequest() {
        RequestAttributes attributes = RequestContextHolder.getRequestAttributes();
        if (attributes instanceof ServletRequestAttributes servletRequestAttributes) {
            return servletRequestAttributes.getRequest();
        }
        return null;
    }
}
