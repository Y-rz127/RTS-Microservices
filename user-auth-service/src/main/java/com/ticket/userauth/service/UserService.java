package com.ticket.userauth.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.ticket.model.entity.User;
import com.ticket.model.request.LoginRequest;
import com.ticket.model.request.RegisterRequest;
import com.ticket.model.response.LoginResponse;
import com.ticket.model.response.Result;
import org.springframework.security.core.userdetails.UserDetailsService;

/**
 * 用户服务接口。
 */
public interface UserService extends IService<User>, UserDetailsService {
    /**
     * 用户登录。
     */
    Result<LoginResponse> login(LoginRequest loginRequest);

    /**
     * 用户注册。
     */
    Result<Boolean> register(RegisterRequest registerRequest);

    /**
     * 根据用户名获取用户。
     */
    User getUserByUsername(String username);

    /**
     * 更新用户信息。
     */
    Result<Boolean> updateUser(User user);

    /**
     * 修改密码。
     */
    Result<Boolean> changePassword(Integer userId, String oldPassword, String newPassword);

    /**
     * 更新用户状态。
     */
    Result<Boolean> updateUserStatus(Integer userId, Integer status);

    /**
     * 分页查询用户列表。
     */
    Result<Object> getUserPage(com.ticket.model.request.PageRequest pageRequest,
                                String username, String role, Integer status);
}
