package com.ticket.model.response;

import lombok.Data;

/**
 * 统一返回结果类
 * @param <T> 数据类型
 */
@Data
public class Result<T> {
    
    /**
     * 状态码
     */
    private Integer code;
    
    /**
     * 消息
     */
    private String message;
    
    /**
     * 数据
     */
    private T data;
    
    public Result() {}
    
    public Result(Integer code, String message, T data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }
    
    /**
     * 成功返回结果
     * @param data 数据
     * @param <T> 数据类型
     * @return Result
     */
    public static <T> Result<T> success(T data) {
        return new Result<>(200, "操作成功", data);
    }
    
    /**
     * 成功返回结果（带消息）
     * @param data 数据
     * @param message 消息
     * @param <T> 数据类型
     * @return Result
     */
    public static <T> Result<T> success(T data, String message) {
        return new Result<>(200, message, data);
    }
    
    /**
     * 成功返回结果（无数据）
     * @return Result
     */
    public static <T> Result<T> success() {
        return new Result<>(200, "操作成功", null);
    }
    
    /**
     * 失败返回结果
     * @param message 错误消息
     * @param <T> 数据类型
     * @return Result
     */
    public static <T> Result<T> error(String message) {
        return new Result<>(500, message, null);
    }
    
    /**
     * 失败返回结果（带状态码）
     * @param code 状态码
     * @param message 错误消息
     * @param <T> 数据类型
     * @return Result
     */
    public static <T> Result<T> error(Integer code, String message) {
        return new Result<>(code, message, null);
    }
    
    /**
     * 未授权返回结果
     * @param message 消息
     * @param <T> 数据类型
     * @return Result
     */
    public static <T> Result<T> unauthorized(String message) {
        return new Result<>(401, message, null);
    }
    
    /**
     * 禁止访问返回结果
     * @param message 消息
     * @param <T> 数据类型
     * @return Result
     */
    public static <T> Result<T> forbidden(String message) {
        return new Result<>(403, message, null);
    }
    
    /**
     * 参数错误返回结果
     * @param message 消息
     * @param <T> 数据类型
     * @return Result
     */
    public static <T> Result<T> badRequest(String message) {
        return new Result<>(400, message, null);
    }
    
    /**
     * 判断是否成功
     * @return boolean
     */
    public boolean isSuccess() {
        return this.code != null && this.code == 200;
    }
}
