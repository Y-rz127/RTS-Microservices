package com.ticket.filter;

import com.ticket.utils.JwtUtils;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

/**
 * Header 认证过滤器，从 HTTP 请求头中获取用户信息并设置到 SecurityContext。
 */
@Component
public class HeaderAuthenticationFilter extends OncePerRequestFilter {

    private final JwtUtils jwtUtils;

    public HeaderAuthenticationFilter(JwtUtils jwtUtils) {
        this.jwtUtils = jwtUtils;
    }

    /**
     * 过滤器内部处理。
     */
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        if (SecurityContextHolder.getContext().getAuthentication() == null) {
            String userId = null;
            String role = null;
            String signedUserId = request.getHeader("X-User-Id");
            String signedRole = request.getHeader("X-User-Role");
            String timestamp = request.getHeader("X-Auth-Timestamp");
            String signature = request.getHeader("X-Auth-Signature");

            if (jwtUtils.isValidInternalRequest(signedUserId, signedRole, timestamp, signature)) {
                userId = signedUserId;
                role = signedRole;
            } else {
                String authorization = request.getHeader("Authorization");
                if (authorization != null && authorization.startsWith("Bearer ")) {
                    try {
                        String token = authorization.substring(7);
                        userId = jwtUtils.extractUserId(token);
                        role = jwtUtils.extractRole(token);
                    } catch (Exception ignored) {
                    }
                }
            }

            if (userId != null && !userId.isBlank()) {
                List<SimpleGrantedAuthority> authorities = Collections.emptyList();
                if (role != null && !role.isBlank()) {
                    String normalizedRole = role.startsWith("ROLE_") ? role : "ROLE_" + role;
                    authorities = List.of(new SimpleGrantedAuthority(normalizedRole));
                }

                UsernamePasswordAuthenticationToken authenticationToken =
                        new UsernamePasswordAuthenticationToken(userId, null, authorities);
                SecurityContextHolder.getContext().setAuthentication(authenticationToken);
            }
        }

        filterChain.doFilter(request, response);
    }
}
