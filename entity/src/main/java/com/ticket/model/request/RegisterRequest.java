package com.ticket.model.request;

import lombok.Data;

@Data
public class RegisterRequest {
    /**
     * 用户名
     */
    private String username;

    /**
     * 密码
     */
    private String password;

    /**
     * 用户角色：ADMIN（系统管理员）、OPERATOR（售票员）、PASSENGER (乘客)
     */
    private String role;

    /**
     * 联系电话
     */
    private String phone;

    /**
     * 状态：0-禁用，1-启用
     */
    private Integer status;

}
