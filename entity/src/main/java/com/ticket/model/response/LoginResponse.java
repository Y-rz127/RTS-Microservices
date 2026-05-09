package com.ticket.model.response;

import com.ticket.model.entity.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 登录响应类
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponse {
    
    /**
     * JWT Token
     */
    private String token;
    
    /**
     * 用户信息
     */
    private User user;
}
