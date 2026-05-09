package com.ticket.userauth.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ticket.model.entity.User;
import com.ticket.model.request.LoginRequest;
import com.ticket.model.request.RegisterRequest;
import com.ticket.model.response.LoginResponse;
import com.ticket.model.response.Result;
import com.ticket.userauth.mapper.UserMapper;
import com.ticket.userauth.service.UserService;
import com.ticket.utils.JwtUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.Date;
import java.util.List;

/**
 * 用户认证与权限管理服务实现，处理登录、注册、密码修改、用户信息更新等操作。
 * 集成 Spring Security 提供 UserDetails 实现，支持 JWT Token 签发。
 * @author 铁路票务系统
 */
@Service
@Primary
@Slf4j
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UserMapper userMapper;

    private static final List<String> LEGAL_ROLES = List.of("ADMIN", "OPERATOR", "PASSENGER");
    private static final int PASSWORD_MIN_LENGTH = 6;
    private static final String AUTO_REGISTER_DEFAULT_ROLE = "PASSENGER";
    private static final Integer AUTO_REGISTER_DEFAULT_STATUS = 1;

    /**
     * 用户登录。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<LoginResponse> login(LoginRequest req) {
        try {
            if (req == null || !StringUtils.hasText(req.getUsername()) || !StringUtils.hasText(req.getPassword())) {
                return Result.error("用户名或密码不能为空");
            }
            String username = req.getUsername().trim();
            String password = req.getPassword().trim();

            User user = getUserByUsername(username);
            if (user == null) {
                // 安全考虑：不再自动注册，避免任意用户名创建账号
                log.info("用户 {} 不存在，登录失败", username);
                return Result.error("用户名或密码错误");
            }

            if (Integer.valueOf(0).equals(user.getStatus())) return Result.error("账号已被禁用，请联系管理员");

            if (!passwordEncoder.matches(password, user.getPassword())) {
                return Result.error("用户名或密码错误");
            }

            String token = jwtUtils.generateToken(buildUserDetails(user), user.getRole(), user.getUserid().toString());

            LoginResponse resp = new LoginResponse();
            resp.setToken(token);
            user.setPassword(null);
            resp.setUser(user);
            log.info("用户 {} 登录成功", username);
            return Result.success(resp);

        } catch (Exception e) {
            log.error("登录失败", e);
            return Result.error(e.getMessage());
        }
    }

    /**
     * 用户注册。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Boolean> register(RegisterRequest req) {
        try {
            if (req == null || !StringUtils.hasText(req.getUsername()) || !StringUtils.hasText(req.getPassword())
                    || !StringUtils.hasText(req.getRole()) || !StringUtils.hasText(req.getPhone())) {
                return Result.error("必填项不能为空（用户名、密码、角色、电话）");
            }

            String username = req.getUsername().trim();
            if (getUserByUsername(username) != null) return Result.error("用户名已存在");
            if (req.getPassword().length() < PASSWORD_MIN_LENGTH) return Result.error("密码长度至少 " + PASSWORD_MIN_LENGTH + " 位");
            // 安全考虑：公开注册接口只允许注册为乘客角色，避免任意注册管理员账号
            if (!"PASSENGER".equals(req.getRole())) {
                return Result.error("注册只支持乘客角色，管理员/操作员账号需由管理员在后台创建");
            }

            User user = new User();
            user.setUsername(username);
            user.setPassword(passwordEncoder.encode(req.getPassword()));
            user.setRole(req.getRole());
            user.setPhone(req.getPhone());
            user.setStatus(req.getStatus() != null ? req.getStatus() : 1);
            user.setCreateTime(new Date());
            user.setUpdateTime(new Date());

            return save(user) ? Result.success(true) : Result.error("保存用户信息失败");
        } catch (Exception e) {
            log.error("注册用户异常", e);
            return Result.error("系统异常，请稍后重试");
        }
    }

    /**
     * 根据用户名查询用户。
     */
    @Override
    public User getUserByUsername(String username) {
        if (!StringUtils.hasText(username)) return null;
        return userMapper.selectOne(new LambdaQueryWrapper<User>().eq(User::getUsername, username.trim()));
    }

    /**
     * 更新用户信息。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Boolean> updateUser(User user) {
        try {
            if (user == null || user.getUserid() == null) return Result.error("用户ID不能为空");
            User exist = getById(user.getUserid());
            if (exist == null) return Result.error("用户不存在");

            if (StringUtils.hasText(user.getRole()) && !LEGAL_ROLES.contains(user.getRole().trim())) return Result.error("非法角色");
            if (user.getStatus() != null && !List.of(0, 1).contains(user.getStatus())) return Result.error("非法状态值");

            user.setPassword(null);
            user.setUpdateTime(new Date());
            return updateById(user) ? Result.success(true) : Result.error("更新失败");
        } catch (Exception e) {
            log.error("更新用户失败", e);
            return Result.error("系统异常");
        }
    }

    /**
     * 修改密码。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Boolean> changePassword(Integer userId, String oldPwd, String newPwd) {
        try {
            if (userId == null || !StringUtils.hasText(oldPwd) || !StringUtils.hasText(newPwd)) return Result.error("参数不全");
            User user = getById(userId);
            if (user == null) return Result.error("用户不存在");

            if (!passwordEncoder.matches(oldPwd, user.getPassword())) return Result.error("原密码错误");
            if (newPwd.length() < PASSWORD_MIN_LENGTH) return Result.error("新密码太短");
            if (oldPwd.equals(newPwd)) return Result.error("新旧密码不能一致");

            user.setPassword(passwordEncoder.encode(newPwd));
            user.setUpdateTime(new Date());
            return updateById(user) ? Result.success(true) : Result.error("修改失败");
        } catch (Exception e) {
            log.error("修改密码失败", e);
            return Result.error("修改失败");
        }
    }

    /**
     * 更新用户状态。
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<Boolean> updateUserStatus(Integer userId, Integer status) {
        try {
            if (userId == null || status == null) return Result.error("参数缺失");
            User user = getById(userId);
            if (user == null) return Result.error("用户不存在");
            if ("ADMIN".equals(user.getRole()) && status == 0) return Result.error("核心管理账号不可禁用");

            return userMapper.update(null, new LambdaUpdateWrapper<User>()
                    .eq(User::getUserid, userId).set(User::getStatus, status).set(User::getUpdateTime, new Date())) > 0
                    ? Result.success(true) : Result.error("更新失败");
        } catch (Exception e) {
            log.error("修改状态异常", e);
            return Result.error("操作异常");
        }
    }

    /**
     * 加载用户详情（Spring Security）。
     */
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = getUserByUsername(username);
        if (user == null) throw new UsernameNotFoundException("用户不存在");
        return buildUserDetails(user);
    }

    /**
     * 自动注册用户。
     */
    private User autoRegister(String username, String pwd) throws Exception {
        if (pwd.length() < PASSWORD_MIN_LENGTH) throw new Exception("初始密码至少 " + PASSWORD_MIN_LENGTH + " 位");
        User u = new User();
        u.setUsername(username);
        u.setPassword(passwordEncoder.encode(pwd));
        u.setRole(AUTO_REGISTER_DEFAULT_ROLE);
        u.setStatus(AUTO_REGISTER_DEFAULT_STATUS);
        u.setCreateTime(new Date());
        u.setUpdateTime(new Date());
        return save(u) ? u : null;
    }

    /**
     * 构建用户详情。
     */
    private UserDetails buildUserDetails(User user) {
        return new org.springframework.security.core.userdetails.User(
                user.getUsername(), user.getPassword(), Integer.valueOf(1).equals(user.getStatus()),
                true, true, true, getAuthorities(user.getRole())
        );
    }

    /**
     * 获取用户权限列表。
     */
    private List<GrantedAuthority> getAuthorities(String role) {
        return StringUtils.hasText(role) ? List.of(() -> "ROLE_" + role.trim()) : List.of();
    }

    /**
     * 分页查询用户列表。
     */
    @Override
    public Result<Object> getUserPage(com.ticket.model.request.PageRequest pageReq, String username, String role, Integer status) {
        try {
            Page<User> page = new Page<>(pageReq.getPageNum(), pageReq.getPageSize());
            LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
            if (StringUtils.hasText(username)) wrapper.like(User::getUsername, username);
            if (StringUtils.hasText(role)) wrapper.eq(User::getRole, role);
            if (status != null) wrapper.eq(User::getStatus, status);

            wrapper.orderByDesc(User::getCreateTime);
            Page<User> res = userMapper.selectPage(page, wrapper);
            res.getRecords().forEach(u -> u.setPassword(null));
            return Result.success(res);
        } catch (Exception e) {
            log.error("用户分页查询失败", e);
            return Result.error("查询失败：" + e.getMessage());
        }
    }
}
