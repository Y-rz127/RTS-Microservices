package com.ticket.utils;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * JWT 工具类，用于生成和验证 JWT Token。
 */
@Component
public class JwtUtils {

    private static final String HMAC_SHA256 = "HmacSHA256";
    private static final long INTERNAL_HEADER_TTL_MILLIS = 5 * 60 * 1000L;

    @Value("${jwt.secret}")
    private String jwtSecret;

    @Value("${jwt.expire}")
    private int jwtExpirationMs;  //jwt过期时间

    /**
     * 生成 JWT Token。
     */
    public String generateToken(UserDetails userDetails, String role, String userId) {
        // 创建声明
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", role);
        claims.put("userId", userId);

        // 生成token - 使用新的API
        return Jwts.builder()
                .claims(claims)  // 使用新的claims方法
                .subject(userDetails.getUsername())
                .issuedAt(new Date())
                .expiration(new Date((new Date()).getTime() + (long) jwtExpirationMs * 60 * 1000L)) // 修复类型转换
                .signWith(getSigningKey())  // 不再需要SignatureAlgorithm参数
                .compact();
    }

    /**
     * 从 Token 中提取用户名。
     */
    public String extractUsername(String token) {
        return extractAllClaims(token).getSubject();
    }

    /**
     * 从 Token 中提取用户 ID。
     */
    public String extractUserId(String token) {
        return extractAllClaims(token).get("userId", String.class);
    }

    /**
     * 提取用户角色
     */
    public String extractRole(String token) {
        return extractAllClaims(token).get("role", String.class);
    }

    /**
     * 从 Token 中提取所有声明（使用 JJWT 0.12+ 新版 API）。
     */
    public Claims extractAllClaims(String token) {
        return Jwts.parser()
                .verifyWith(getSigningKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    /**
     * 验证 Token 是否有效。
     */
    public Boolean validateToken(String token, UserDetails userDetails) {
        try {
            final String username = extractUsername(token);
            return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 检查 Token 是否过期。
     */
    public Boolean isTokenExpired(String token) {
        return extractAllClaims(token).getExpiration().before(new Date());
    }

    public String buildInternalRequestSignature(String userId, String role, String timestamp) {
        try {
            Mac mac = Mac.getInstance(HMAC_SHA256);
            mac.init(new SecretKeySpec(getSigningKeyBytes(), HMAC_SHA256));
            byte[] digest = mac.doFinal(buildInternalPayload(userId, role, timestamp).getBytes(StandardCharsets.UTF_8));
            return Base64.getUrlEncoder().withoutPadding().encodeToString(digest);
        } catch (Exception e) {
            throw new IllegalStateException("Failed to build internal request signature", e);
        }
    }

    public boolean isValidInternalRequest(String userId, String role, String timestamp, String signature) {
        if (isBlank(userId) || isBlank(timestamp) || isBlank(signature)) {
            return false;
        }
        try {
            long requestTimestamp = Long.parseLong(timestamp);
            if (Math.abs(System.currentTimeMillis() - requestTimestamp) > INTERNAL_HEADER_TTL_MILLIS) {
                return false;
            }
            String expected = buildInternalRequestSignature(userId, role, timestamp);
            return MessageDigest.isEqual(expected.getBytes(StandardCharsets.UTF_8), signature.getBytes(StandardCharsets.UTF_8));
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * 获取签名密钥（HMAC SHA SecretKey）。
     * 当配置密钥不足 32 字节时自动填充，确保满足 JJWT 最小长度要求。
     */
    private SecretKey getSigningKey() {
        return Keys.hmacShaKeyFor(getSigningKeyBytes());
    }

    private byte[] getSigningKeyBytes() {
        byte[] keyBytes = jwtSecret.getBytes(StandardCharsets.UTF_8);
        if (keyBytes.length < 32) {
            byte[] paddedKey = new byte[32];
            System.arraycopy(keyBytes, 0, paddedKey, 0, keyBytes.length);
            return paddedKey;
        }
        return keyBytes;
    }

    private String buildInternalPayload(String userId, String role, String timestamp) {
        return userId + "|" + (role == null ? "" : role) + "|" + timestamp;
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }
}