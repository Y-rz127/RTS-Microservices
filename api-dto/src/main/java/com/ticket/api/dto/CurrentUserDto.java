package com.ticket.api.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 当前用户数据传输对象。
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CurrentUserDto {
    private Integer userId;
    private String username;
    private String role;
}
