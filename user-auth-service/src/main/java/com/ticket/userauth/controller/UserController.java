package com.ticket.userauth.controller;

import com.ticket.annotation.Log;
import com.ticket.model.entity.User;
import com.ticket.model.request.LoginRequest;
import com.ticket.model.request.PageRequest;
import com.ticket.model.request.RegisterRequest;
import com.ticket.model.response.LoginResponse;
import com.ticket.model.response.Result;
import com.ticket.userauth.service.UserService;
import com.alibaba.csp.sentinel.annotation.SentinelResource;
import com.alibaba.csp.sentinel.slots.block.BlockException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

/**
 * 用户相关接口控制器。
 */
@RestController
@RequestMapping("/api/user")
public class UserController {

    private final UserService userService;

    private static final String BUSY_MESSAGE = "系统繁忙，请稍后重试（用户服务限流）";

    public UserController(UserService userService) {
        this.userService = userService;
    }

    /**
     * 处理用户登录。
     */
    @PostMapping("/login")
    @SentinelResource(value = "userLogin", blockHandler = "loginBlockHandler")
    @Log(module = "用户认证", operation = "登录", saveParams = false)
    public Result<LoginResponse> login(@RequestBody LoginRequest loginRequest) {
        return userService.login(loginRequest);
    }

    /**
     * 处理用户注册。
     */
    @PostMapping("/register")
    @SentinelResource(value = "userRegister", blockHandler = "registerBlockHandler")
    @Log(module = "用户认证", operation = "新增", saveParams = false)
    public Result<Boolean> register(@RequestBody RegisterRequest registerRequest) {
        return userService.register(registerRequest);
    }

    /**
     * 处理用户登出。
     */
    @PostMapping("/logout")
    @Log(module = "用户认证", operation = "登出")
    public Result<Boolean> logout() {
        return Result.success(true);
    }

    /**
     * 获取当前登录用户。
     */
    @GetMapping("/current")
    @SentinelResource(value = "userCurrent", blockHandler = "currentUserBlockHandler")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATOR', 'PASSENGER')")
    public Result<User> getCurrentUser() {
        String username = org.springframework.security.core.context.SecurityContextHolder.getContext()
                .getAuthentication().getName();
        User user = userService.getUserByUsername(username);
        user.setPassword(null);
        return Result.success(user);
    }

    /**
     * 更新当前用户信息。
     */
    @PutMapping("/update")
    @SentinelResource(value = "userUpdate", blockHandler = "updateUserBlockHandler")
    @PreAuthorize("hasAnyRole('ADMIN', 'OPERATOR','PASSENGER')")
    @Log(module = "用户管理", operation = "修改")
    public Result<Boolean> updateUser(@RequestBody User user) {
        return userService.updateUser(user);
    }

    /**
     * 修改当前用户密码。
     */
    @PostMapping("/changePassword")
    @SentinelResource(value = "userChangePassword", blockHandler = "changePasswordBlockHandler")
    @PreAuthorize("isAuthenticated()")
    public Result<Boolean> changePassword(@RequestParam String oldPassword, @RequestParam String newPassword) {
        String username = org.springframework.security.core.context.SecurityContextHolder.getContext()
                .getAuthentication().getName();
        User user = userService.getUserByUsername(username);
        return userService.changePassword(user.getUserid(), oldPassword, newPassword);
    }

    /**
     * 分页查询用户列表。
     */
    @GetMapping("/page")
    @SentinelResource(value = "userPage", blockHandler = "userPageBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    @Log(module = "用户管理", operation = "查询", saveParams = false)
    public Result<Object> getUserPage(PageRequest pageRequest,
                                     @RequestParam(required = false) String username,
                                     @RequestParam(required = false) String role,
                                     @RequestParam(required = false) Integer status) {
        return userService.getUserPage(pageRequest, username, role, status);
    }

    /**
     * 按用户编号更新用户信息。
     */
    @PutMapping("/{userId}")
    @SentinelResource(value = "userUpdateById", blockHandler = "updateUserByIdBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    public Result<Boolean> updateUserById(@PathVariable Integer userId, @RequestBody User user) {
        user.setUserid(userId);
        return userService.updateUser(user);
    }

    /**
     * 删除指定用户。
     */
    @DeleteMapping("/{userId}")
    @SentinelResource(value = "userDelete", blockHandler = "deleteUserBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    @Log(module = "用户管理", operation = "删除")
    public Result<Boolean> deleteUser(@PathVariable Integer userId) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof UserDetails userDetails) {
            String currentUsername = userDetails.getUsername();
            User userToDelete = userService.getById(userId);
            if (userToDelete != null && userToDelete.getUsername().equals(currentUsername)) {
                return Result.error("不能删除自己的账号");
            }
        }
        boolean success = userService.removeById(userId);
        return success ? Result.success(true) : Result.error("删除失败");
    }

    /**
     * 更新用户状态。
     */
    @PutMapping("/status/{userId}")
    @SentinelResource(value = "userStatusUpdate", blockHandler = "updateUserStatusBlockHandler")
    @PreAuthorize("hasRole('ADMIN')")
    @Log(module = "用户管理", operation = "修改")
    public Result<Boolean> updateUserStatus(@PathVariable Integer userId, @RequestParam Integer status) {
        return userService.updateUserStatus(userId, status);
    }

    // --- 内部调用接口 (Internal Only) ---

    /**
     * 按编号查询用户。
     */
    @GetMapping("/{userId}")
    public Result<User> getUserById(@PathVariable Integer userId) {
        User user = userService.getById(userId);
        if (user != null) user.setPassword(null);
        return user != null ? Result.success(user) : Result.error("用户不存在");
    }

    /**
     * 按用户名查询用户。
     */
    @GetMapping("/internal/byUsername/{username}")
    public Result<User> getUserByUsernameInternal(@PathVariable String username) {
        User user = userService.getUserByUsername(username);
        if (user != null) user.setPassword(null);
        return user != null ? Result.success(user) : Result.error("用户不存在");
    }

    /**
     * 登录限流处理。
     */
    public static Result<LoginResponse> loginBlockHandler(LoginRequest loginRequest, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 注册限流处理。
     */
    public static Result<Boolean> registerBlockHandler(RegisterRequest registerRequest, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 获取当前用户限流处理。
     */
    public static Result<User> currentUserBlockHandler(BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 更新用户限流处理。
     */
    public static Result<Boolean> updateUserBlockHandler(User user, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 修改密码限流处理。
     */
    public static Result<Boolean> changePasswordBlockHandler(String oldPassword, String newPassword, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 分页查询用户限流处理。
     */
    public static Result<Object> userPageBlockHandler(PageRequest pageRequest, String username, String role, Integer status, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 按编号更新用户限流处理。
     */
    public static Result<Boolean> updateUserByIdBlockHandler(Integer userId, User user, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 删除用户限流处理。
     */
    public static Result<Boolean> deleteUserBlockHandler(Integer userId, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }

    /**
     * 更新用户状态限流处理。
     */
    public static Result<Boolean> updateUserStatusBlockHandler(Integer userId, Integer status, BlockException ex) {
        return Result.error(BUSY_MESSAGE);
    }
}
